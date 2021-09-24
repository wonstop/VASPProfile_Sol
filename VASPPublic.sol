pragma solidity >=0.4.22 <0.7.0;
//pragma experimental ABIEncoderV2;

contract VASPPlatform {
    struct ShareVASPProperty {
        bool status;
        string vcode;
        string ctrycode;
    }
    address regulatoryAuthority;
    
    mapping(string => mapping(string =>address)) VASPInfo;
    mapping(string => mapping(string => ShareVASPProperty)) shareVASP;
    
    constructor() public {
        regulatoryAuthority = msg.sender;
    }
    
    /*政府建立VASP*/
    function registerVASP(
        string memory _vcode,
        string memory _ctrycode,
        address _VASPAddress
    ) public {
        require(
            msg.sender == regulatoryAuthority,
            "You are not a regulator，[_VASPAddress] Error."
        );
        VASPInfo[_vcode][_ctrycode] = address(_VASPAddress);
        shareVASP[_vcode][_ctrycode].status = true;

    }
    
    function getVASP(string _vcode, string _ctrycode) public view returns (bool) {
        return shareVASP[_vcode][_ctrycode].status;
    }
    function getVASPaddr(string _vcode, string _ctrycode) public view returns (address) {
        //return shareVASP[_vcode][_ctrycode].status;
        return VASPInfo[_vcode][_ctrycode];
    }
    /*政府取消VASP*/
    function cancelVASP(
        string memory _vcode,
        string memory _ctrycode,
        address _VASPAddress
    ) public {
        require(
            msg.sender == regulatoryAuthority,
            "You are not a regulator，[_VASPAddress] Error."
        );
        VASPInfo[_vcode][_ctrycode] = address(_VASPAddress);
        shareVASP[_vcode][_ctrycode].status = false;

    }

}

