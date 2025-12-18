public class NameAssignmentHandler {

    public static String getAssignedStaff(String fullName) {
        if (String.isBlank(fullName)) return 'Unknown';

        String name = fullName.trim().toLowerCase();

        if (name < 'anto') return 'Waqas Saeed';
        if (name < 'catherineg') return 'Waqar Afraz'; // F is before G
        if (name < 'dianab') return 'Tamoor Ahmed';
        if (name < 'felm') return 'Shahzaib Afraz';
        if (name < 'hj') return 'Adeel Munawar'; // HI is before HJ
        if (name < 'jf') return 'Rayyan Manzoor'; // Je to Jf
        if (name < 'jue') return 'Hamza Hafeez'; // Jud before Jue
        if (name < 'la') return 'Nazir Hussain'; // K to L
        if (name < 'lv') return 'Aqib Hameed';   // Lu before Lv
        if (name < 'mauz') return 'Angela';      // Mat before Mau
        if (name < 'nao') return 'Aamir Gulzar'; // Nan before Nao
        if (name < 'q') return 'Anees Awan';     // P before Q
        if (name < 'rot') return 'Toseeq Dilpazir'; // Ros before Rot
        if (name < 'suta') return 'Hassan Ali';     // Sus before Suta
        if (name < 'valerinf') return 'Sabeel Ahmed'; // Valerie before Valerinf
        return 'Zaryab Zahoor';
    }
}