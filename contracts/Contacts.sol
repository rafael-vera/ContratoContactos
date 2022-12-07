// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/// @title Contacts
/// @author Rafael Vera, Karen Peña
/// @notice Contrato para que los usuarios puedan crear contactos
contract Contacts {
    /// @notice Estructura de un contacto
    struct Contact {
        string firstName;       // Nombre del contacto
        string lastName;        // Apellido del contacto
        string telephoneNumber; // Número de teléfono del contacto
        string email;           // Correo del contacto
        address account;        // Dirección de blockchain del contacto
    }
    
    /// @notice Evento para contactos agregados
    /// @param sender - La dirección de quien agrega el contacto
    /// @param id - El ID del contacto agregado
    /// @param firstName - El nombre del contacto agregado
    /// @param lastName - El apellido del contacto agregado
    /// @param telephoneNumber - El número de teléfono del contacto agregado
    /// @param email - El correo del contacto agregado
    /// @param account - La dirección de blockchain del contacto agregado
    event ContactAdded(
        address indexed sender,
        uint256 id,
        string firstName,
        string lastName,
        string telephoneNumber,
        string email,
        address account
    );
    
    /// @notice Evento para contactos actualizados
    /// @param sender - La dirección de quien edita el contacto
    /// @param id - El ID del contacto editado
    /// @param firstName - El nuevo nombre del contacto editado
    /// @param lastName - El nuevo apellido del contacto editado
    /// @param telephoneNumber - El nuevo número de teléfono del contacto editado
    /// @param email - El nuevo correo del contacto editado
    /// @param account - La nueva dirección de blockchain del contacto editado
    event ContactUpdated(
        address indexed sender,
        uint256 id,
        string firstName,
        string lastName,
        string telephoneNumber,
        string email,
        address account
    );
    
    /// @notice Evento para contactos eliminados
    /// @param sender - La dirección de quien elimina el contacto
    /// @param id - El ID del contacto eliminado
    /// @param replacedByID - El ID del contacto que toma el lugar del eliminado
    event ContactDeleted(
        address indexed sender,
        uint256 id,
        uint256 replacedByID
    );
    
    /// @dev Variable que almacena el último indice de contacto de cada usuario
    mapping(address => uint256) lastIndex;
    
    /// @dev Variable que almacena los contactos de cada usuario
    mapping(address => mapping(uint256 => Contact)) contacts;
    
    /// @notice Función que obtiene la lista de contactos del usuario que llama al contrato
    /// @return uint256 - La cantidad de contactos del usuario
    /// @return Contact[] - Arreglo con los contactos del usuario
    function getContacts() public view returns (uint256, Contact[] memory) {
        Contact[] memory _contacts = new Contact[](lastIndex[tx.origin]);
        for(uint256 i = 0; i < lastIndex[tx.origin]; i++) {
            _contacts[i] = contacts[tx.origin][i+1];
        }
        return (lastIndex[tx.origin], _contacts);
    }
    
    /// @notice Función que agrega un contacto a la lista del usuario que llama al contrato
    /// @param _firstName - Nombre del contacto a registrar
    /// @param _lastName - Apellido del contacto a registrar
    /// @param _telephoneNumber - Apellido del contacto a registrar
    /// @param _email - Apellido del contacto a registrar
    /// @param _account - Apellido del contacto a registrar
    function addContact(
        string memory _firstName,
        string memory _lastName,
        string memory _telephoneNumber,
        string memory _email,
        address _account
    ) public {
        lastIndex[tx.origin]++;
        contacts[tx.origin][lastIndex[tx.origin]] = Contact(
            _firstName,
            _lastName,
            _telephoneNumber,
            _email,
            _account
        );
        emit ContactAdded(
            tx.origin,
            lastIndex[tx.origin],
            _firstName,
            _lastName,
            _telephoneNumber,
            _email,
            _account
        );
    }
    
    /// @notice Función que actualiza la información de un contacto del usuario que llama al contrato
    /// @param _firstName - El nuevo nombre del contacto
    /// @param _lastName - El nuevo apellido del contacto
    /// @param _telephoneNumber - El nuevo número de teléfono del contacto
    /// @param _email - El nuevo correo del contacto
    /// @param _account - La nueva dirección de blockchain del contacto
    function updateContact(
        uint256 _id,
        string memory _firstName,
        string memory _lastName,
        string memory _telephoneNumber,
        string memory _email,
        address _account
    ) public {
        require(_id > 0 && _id <= lastIndex[tx.origin], "ID out of range");
        contacts[tx.origin][_id] = Contact(
            _firstName,
            _lastName,
            _telephoneNumber,
            _email,
            _account
        );
        emit ContactUpdated(
            tx.origin,
            _id,
            _firstName,
            _lastName,
            _telephoneNumber,
            _email,
            _account
        );
    }
    
    /// @notice Función que elimina un contacto dado su ID
    /// @dev Elimina el contacto y reemplaza el último por el ID del eliminado
    /// @param _id - El ID del contacto a eliminar
    function deleteContact(uint256 _id) public {
        require(_id > 0 && _id <= lastIndex[tx.origin], "ID out of range");
        delete contacts[tx.origin][_id];
        contacts[tx.origin][_id] = contacts[tx.origin][lastIndex[tx.origin]];
        delete contacts[tx.origin][lastIndex[tx.origin]];
        lastIndex[tx.origin]--;
        emit ContactDeleted(tx.origin, _id, lastIndex[tx.origin] + 1);
    }
}