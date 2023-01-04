/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import {
  Signer,
  utils,
  Contract,
  ContractFactory,
  BigNumberish,
  Overrides,
} from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../common";
import type {
  EasySendCrypto,
  EasySendCryptoInterface,
} from "../../contracts/EasySendCrypto";

const _abi = [
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_fee_rate",
        type: "uint256",
      },
      {
        internalType: "address",
        name: "_fee_collect_address",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "bytes",
        name: "data",
        type: "bytes",
      },
    ],
    name: "Data",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "token_address",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "sender",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "receiver",
        type: "address",
      },
      {
        indexed: false,
        internalType: "bool",
        name: "is_swap",
        type: "bool",
      },
      {
        indexed: false,
        internalType: "address",
        name: "swap_token_address",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "swap_amount",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "swap_deadline",
        type: "uint256",
      },
    ],
    name: "New_Order",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
    ],
    name: "Order_Cancelled",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
    ],
    name: "Order_Completed",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "bytes32",
        name: "previousAdminRole",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "bytes32",
        name: "newAdminRole",
        type: "bytes32",
      },
    ],
    name: "RoleAdminChanged",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "sender",
        type: "address",
      },
    ],
    name: "RoleGranted",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        indexed: true,
        internalType: "address",
        name: "account",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "sender",
        type: "address",
      },
    ],
    name: "RoleRevoked",
    type: "event",
  },
  {
    inputs: [],
    name: "DEFAULT_ADMIN_ROLE",
    outputs: [
      {
        internalType: "bytes32",
        name: "",
        type: "bytes32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_token_address",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_amount",
        type: "uint256",
      },
      {
        internalType: "bytes32",
        name: "_passphrase",
        type: "bytes32",
      },
      {
        internalType: "address",
        name: "_receiver",
        type: "address",
      },
      {
        internalType: "bool",
        name: "_is_swap",
        type: "bool",
      },
      {
        internalType: "address",
        name: "_swap_token_address",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_swap_amount",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_swap_deadline",
        type: "uint256",
      },
    ],
    name: "add_order",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "passphrase",
        type: "bytes32",
      },
    ],
    name: "claim_asset",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "count",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "fee_collect_address",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "fee_rate",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
    ],
    name: "getRoleAdmin",
    outputs: [
      {
        internalType: "bytes32",
        name: "",
        type: "bytes32",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "grantRole",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "hasRole",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "renounceRole",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "passphrase",
        type: "bytes32",
      },
    ],
    name: "retrieve_unclaimed_order",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "role",
        type: "bytes32",
      },
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "revokeRole",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_fee_collect_address",
        type: "address",
      },
    ],
    name: "set_fee_collect_address",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_new_fee_rate",
        type: "uint256",
      },
    ],
    name: "set_fee_rate",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes4",
        name: "interfaceId",
        type: "bytes4",
      },
    ],
    name: "supportsInterface",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

const _bytecode =
  "0x608060405234801561001057600080fd5b506040516200174b3803806200174b83398101604081905261003191610108565b600060018190556002839055600380546001600160a01b0319166001600160a01b0384161790556100629033610069565b5050610145565b6000828152602081815260408083206001600160a01b038516845290915290205460ff16610104576000828152602081815260408083206001600160a01b03851684529091529020805460ff191660011790556100c33390565b6001600160a01b0316816001600160a01b0316837f2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d60405160405180910390a45b5050565b6000806040838503121561011b57600080fd5b825160208401519092506001600160a01b038116811461013a57600080fd5b809150509250929050565b6115f680620001556000396000f3fe6080604052600436106100e85760003560e01c80636e1008f21161008a578063a217fddf11610059578063a217fddf1461026b578063d547741f14610280578063d5b179cb146102a0578063fcb53d36146102d857600080fd5b80636e1008f2146101f8578063719106c51461021857806391d148541461022b5780639fd815071461024b57600080fd5b8063202b29a2116100c6578063202b29a214610168578063248a9ca3146101885780632f2ff15d146101b857806336568abe146101d857600080fd5b806301ffc9a7146100ed57806306661abd14610122578063100152fd14610146575b600080fd5b3480156100f957600080fd5b5061010d6101083660046112c9565b6102ee565b60405190151581526020015b60405180910390f35b34801561012e57600080fd5b5061013860015481565b604051908152602001610119565b34801561015257600080fd5b506101666101613660046112f3565b610325565b005b34801561017457600080fd5b506101666101833660046112f3565b6104ca565b34801561019457600080fd5b506101386101a33660046112f3565b60009081526020819052604090206001015490565b3480156101c457600080fd5b506101666101d3366004611328565b610516565b3480156101e457600080fd5b506101666101f3366004611328565b610540565b34801561020457600080fd5b506101666102133660046112f3565b6105be565b610166610226366004611362565b61085b565b34801561023757600080fd5b5061010d610246366004611328565b610b62565b34801561025757600080fd5b506101666102663660046113df565b610b8b565b34801561027757600080fd5b50610138600081565b34801561028c57600080fd5b5061016661029b366004611328565b610bf4565b3480156102ac57600080fd5b506003546102c0906001600160a01b031681565b6040516001600160a01b039091168152602001610119565b3480156102e457600080fd5b5061013860025481565b60006001600160e01b03198216637965db0b60e01b148061031f57506301ffc9a760e01b6001600160e01b03198316145b92915050565b6000818152600460208181526040928390208351610140810185528154815260018201546001600160a01b03908116938201939093526002820154948101949094526003810154606085015291820154811660808401819052600583015480831660a0860152600160a01b900460ff16151560c0850152600683015490911660e0840152600782015461010084015260089091015461012083015233146104135760405162461bcd60e51b815260206004820152601860248201527f4e6f7420616c6c6f77207265747269657665206173736574000000000000000060448201526064015b60405180910390fd5b61042a816080015182604001518360200151610c19565b80516040519081527f2807be01e8c0a1057e0a49c851fcd4d7195d56121b8593255e6fb994ae3e31c09060200160405180910390a150600090815260046020819052604082208281556001810180546001600160a01b031990811690915560028201849055600382018490559181018054831690556005810180546001600160a81b03191690556006810180549092169091556007810182905560080155565b6104d5600033610b62565b6105115760405162461bcd60e51b815260206004820152600d60248201526c26bab9ba1031329020b236b4b760991b604482015260640161040a565b600255565b60008281526020819052604090206001015461053181610e2c565b61053b8383610e39565b505050565b6001600160a01b03811633146105b05760405162461bcd60e51b815260206004820152602f60248201527f416363657373436f6e74726f6c3a2063616e206f6e6c792072656e6f756e636560448201526e103937b632b9903337b91039b2b63360891b606482015260840161040a565b6105ba8282610ebd565b5050565b6000818152600460208181526040928390208351610140810185528154815260018201546001600160a01b0390811693820193909352600282015494810194909452600381015460608501529182015481166080840152600582015480821660a08501819052600160a01b90910460ff16151560c0850152600683015490911660e08401526007820154610100840152600890910154610120830152331461069f5760405162461bcd60e51b815260206004820152601460248201527320b2323932b9b9903737ba103932b1b2b4bb32b960611b604482015260640161040a565b8060c0015115610756578061012001514211156106ed5760405162461bcd60e51b815260206004820152600c60248201526b14ddd85c08195e1c1a5c995960a21b604482015260640161040a565b600060646002548361010001516107049190611410565b61070e9190611427565b60035460e08401519192506107309133916001600160a01b0316908490610f22565b610754338360a001518385610100015161074a9190611449565b8560e00151610f22565b505b60006064600254836040015161076c9190611410565b6107769190611427565b6003546020840151919250610798916001600160a01b03909116908390610c19565b6107ba8260a001518284604001516107b09190611449565b8460200151610c19565b81516040519081527f993e0191a6f7be8d091d9fd64f9be172b4e6ac4557cec8285ea682f23af7301b9060200160405180910390a15050600090815260046020819052604082208281556001810180546001600160a01b031990811690915560028201849055600382018490559181018054831690556005810180546001600160a81b03191690556006810180549092169091556007810182905560080155565b600086815260046020819052604090912001546001600160a01b0316156108c45760405162461bcd60e51b815260206004820152601a60248201527f43616e6e6f74207573652073616d652070617373706872617365000000000000604482015260640161040a565b831561092c578042111561092c5760405162461bcd60e51b815260206004820152602960248201527f43616e6e6f742073657420646561646c696e65206265666f72652063757272656044820152681b9d081b5bdb595b9d60ba1b606482015260840161040a565b6109383330898b610f22565b600060405180610140016040528060015481526020018a6001600160a01b03168152602001898152602001888152602001336001600160a01b03168152602001876001600160a01b031681526020018615158152602001856001600160a01b0316815260200184815260200183815250905080600460008981526020019081526020016000206000820151816000015560208201518160010160006101000a8154816001600160a01b0302191690836001600160a01b03160217905550604082015181600201556060820151816003015560808201518160040160006101000a8154816001600160a01b0302191690836001600160a01b0316021790555060a08201518160050160006101000a8154816001600160a01b0302191690836001600160a01b0316021790555060c08201518160050160146101000a81548160ff02191690831515021790555060e08201518160060160006101000a8154816001600160a01b0302191690836001600160a01b03160217905550610100820151816007015561012082015181600801559050506001806000828254610adb919061145c565b90915550508051604080519182526001600160a01b038b811660208401528282018b9052336060840152888116608084015287151560a0840152861660c083015260e082018590526101008201849052517f9cfe5bec548cb5104ae7146a8a028266a4d31cd73c29d277f3cbb208997b325a918190036101200190a1505050505050505050565b6000918252602082815260408084206001600160a01b0393909316845291905290205460ff1690565b610b96600033610b62565b610bd25760405162461bcd60e51b815260206004820152600d60248201526c26bab9ba1031329020b236b4b760991b604482015260640161040a565b600380546001600160a01b0319166001600160a01b0392909216919091179055565b600082815260208190526040902060010154610c0f81610e2c565b61053b8383610ebd565b6001600160a01b038116610d0157600080846001600160a01b03168460405160006040518083038185875af1925050503d8060008114610c75576040519150601f19603f3d011682016040523d82523d6000602084013e610c7a565b606091505b509150915081610cc35760405162461bcd60e51b81526020600482015260146024820152732330b4b632b2103a379039b2b7321022ba3432b960611b604482015260640161040a565b7f0b76c48be4e2908f4c9d4eabaf7538e91577fd9ae26db46693fa8d861c6a42fb81604051610cf291906114bf565b60405180910390a15050505050565b6040516370a0823160e01b8152306004820152819083906001600160a01b038316906370a0823190602401602060405180830381865afa158015610d49573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610d6d91906114d2565b1015610db25760405162461bcd60e51b8152602060048201526014602482015273496e73756666696369656e742062616c616e636560601b604482015260640161040a565b60405163a9059cbb60e01b81526001600160a01b0385811660048301526024820185905282169063a9059cbb906044016020604051808303816000875af1158015610e01573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610e2591906114eb565b5050505050565b610e3681336110bb565b50565b610e438282610b62565b6105ba576000828152602081815260408083206001600160a01b03851684529091529020805460ff19166001179055610e793390565b6001600160a01b0316816001600160a01b0316837f2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d60405160405180910390a45050565b610ec78282610b62565b156105ba576000828152602081815260408083206001600160a01b0385168085529252808320805460ff1916905551339285917ff6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b9190a45050565b6001600160a01b038116610f8457813414610f7f5760405162461bcd60e51b815260206004820152601a60248201527f416d6f756e7420616e642076616c7565206e6f74206d61746368000000000000604482015260640161040a565b6110b5565b6040516370a0823160e01b81526001600160a01b038581166004830152829184918316906370a0823190602401602060405180830381865afa158015610fce573d6000803e3d6000fd5b505050506040513d601f19601f82011682018060405250810190610ff291906114d2565b10156110375760405162461bcd60e51b8152602060048201526014602482015273496e73756666696369656e742062616c616e636560601b604482015260640161040a565b6040516323b872dd60e01b81526001600160a01b0386811660048301528581166024830152604482018590528216906323b872dd906064016020604051808303816000875af115801561108e573d6000803e3d6000fd5b505050506040513d601f19601f820116820180604052508101906110b291906114eb565b50505b50505050565b6110c58282610b62565b6105ba576110d281611114565b6110dd836020611126565b6040516020016110ee929190611508565b60408051601f198184030181529082905262461bcd60e51b825261040a916004016114bf565b606061031f6001600160a01b03831660145b60606000611135836002611410565b61114090600261145c565b67ffffffffffffffff8111156111585761115861157d565b6040519080825280601f01601f191660200182016040528015611182576020820181803683370190505b509050600360fc1b8160008151811061119d5761119d611593565b60200101906001600160f81b031916908160001a905350600f60fb1b816001815181106111cc576111cc611593565b60200101906001600160f81b031916908160001a90535060006111f0846002611410565b6111fb90600161145c565b90505b6001811115611273576f181899199a1a9b1b9c1cb0b131b232b360811b85600f166010811061122f5761122f611593565b1a60f81b82828151811061124557611245611593565b60200101906001600160f81b031916908160001a90535060049490941c9361126c816115a9565b90506111fe565b5083156112c25760405162461bcd60e51b815260206004820181905260248201527f537472696e67733a20686578206c656e67746820696e73756666696369656e74604482015260640161040a565b9392505050565b6000602082840312156112db57600080fd5b81356001600160e01b0319811681146112c257600080fd5b60006020828403121561130557600080fd5b5035919050565b80356001600160a01b038116811461132357600080fd5b919050565b6000806040838503121561133b57600080fd5b8235915061134b6020840161130c565b90509250929050565b8015158114610e3657600080fd5b600080600080600080600080610100898b03121561137f57600080fd5b6113888961130c565b975060208901359650604089013595506113a460608a0161130c565b945060808901356113b481611354565b93506113c260a08a0161130c565b925060c0890135915060e089013590509295985092959890939650565b6000602082840312156113f157600080fd5b6112c28261130c565b634e487b7160e01b600052601160045260246000fd5b808202811582820484141761031f5761031f6113fa565b60008261144457634e487b7160e01b600052601260045260246000fd5b500490565b8181038181111561031f5761031f6113fa565b8082018082111561031f5761031f6113fa565b60005b8381101561148a578181015183820152602001611472565b50506000910152565b600081518084526114ab81602086016020860161146f565b601f01601f19169290920160200192915050565b6020815260006112c26020830184611493565b6000602082840312156114e457600080fd5b5051919050565b6000602082840312156114fd57600080fd5b81516112c281611354565b7f416363657373436f6e74726f6c3a206163636f756e742000000000000000000081526000835161154081601785016020880161146f565b7001034b99036b4b9b9b4b733903937b6329607d1b601791840191820152835161157181602884016020880161146f565b01602801949350505050565b634e487b7160e01b600052604160045260246000fd5b634e487b7160e01b600052603260045260246000fd5b6000816115b8576115b86113fa565b50600019019056fea2646970667358221220b1fd0cd9e11db639d83d856b07a84e80e5a38b9dcfa4c0bd52bd195b5585743764736f6c63430008110033";

type EasySendCryptoConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: EasySendCryptoConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class EasySendCrypto__factory extends ContractFactory {
  constructor(...args: EasySendCryptoConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    _fee_rate: PromiseOrValue<BigNumberish>,
    _fee_collect_address: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<EasySendCrypto> {
    return super.deploy(
      _fee_rate,
      _fee_collect_address,
      overrides || {}
    ) as Promise<EasySendCrypto>;
  }
  override getDeployTransaction(
    _fee_rate: PromiseOrValue<BigNumberish>,
    _fee_collect_address: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(
      _fee_rate,
      _fee_collect_address,
      overrides || {}
    );
  }
  override attach(address: string): EasySendCrypto {
    return super.attach(address) as EasySendCrypto;
  }
  override connect(signer: Signer): EasySendCrypto__factory {
    return super.connect(signer) as EasySendCrypto__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): EasySendCryptoInterface {
    return new utils.Interface(_abi) as EasySendCryptoInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): EasySendCrypto {
    return new Contract(address, _abi, signerOrProvider) as EasySendCrypto;
  }
}