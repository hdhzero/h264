#include <iostream>
using namespace std;

int main() {
    string str;
    string top;

    cin >> top;

    while (cin >> str) {
        cout << "ghdl -i " << str << endl;
    }

    cout << "ghdl -m -g " << top << endl;

    return 0;
}
