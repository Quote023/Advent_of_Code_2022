const input = await Deno.readTextFile("../input.txt")

const top3 = input
  .split("\n")
  .reduce((acc, v) => {
    if(v.trim() == "") return [0,...acc]
    return [Number.parseInt(v) + acc[0],...acc.slice(1)]
  },[] as number[])
  .sort((a,b) => b - a)
  .slice(0,3)

console.log("1º: " + top3[0])
console.log("2º: " + top3.reduce((a,b) => a+b,0))