const Utils = {
  truncate: (string, limit) => {
    if(string.length > limit) {
      return string.substring(0, limit-3) + '...';
    } else {
      return string.substring(0, limit);
    }
  },
  compareBy: (attribute) => {
    return (obj1, obj2) => {
      if(obj1[attribute] > obj2[attribute]) {
        return 1
      } else if(obj1[attribute] < obj2[attribute]) {
        return -1
      } else {
        return -1
      }
    }
  },
  compressString: (string) => {
    return string.toLowerCase().replace(/\s/g, '')
  },
  Aux: (props) => {
    return props.children;
  }
};


export default Utils
