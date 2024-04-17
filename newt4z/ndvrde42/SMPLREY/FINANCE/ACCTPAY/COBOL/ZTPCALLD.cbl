        IDENTIFICATION DIVISION.
        PROGRAM-ID. 'ZTPCALLD'.
        DATA DIVISION.
        WORKING-STORAGE SECTION.
        LINKAGE SECTION.
        01  ARG1 PIC X(1).
        01  ARG2 PIC X(10).
        PROCEDURE DIVISION USING ARG1, ARG2.
            MOVE 'UNKNOWN' TO ARG2
            IF ARG1 = 'A' MOVE 'AARDVARK  ' TO ARG2 END-IF
            IF ARG1 = 'B' MOVE 'BABOON    ' TO ARG2 END-IF
            IF ARG1 = 'C' MOVE 'CAMEL     ' TO ARG2 END-IF
            IF ARG1 = 'D' MOVE 'DEER      ' TO ARG2 END-IF
            IF ARG1 = 'E' MOVE 'EAGLE     ' TO ARG2 END-IF
            IF ARG1 = 'F' MOVE 'FALCON    ' TO ARG2 END-IF
            IF ARG1 = 'G' MOVE 'GAZELLE   ' TO ARG2 END-IF
            IF ARG1 = 'H' MOVE 'HAMSTER   ' TO ARG2 END-IF
            IF ARG1 = 'I' MOVE 'IGUANA    ' TO ARG2 END-IF
            IF ARG1 = 'J' MOVE 'JACKAL    ' TO ARG2 END-IF
            IF ARG1 = 'K' MOVE 'KANGAROO  ' TO ARG2 END-IF
            IF ARG1 = 'L' MOVE 'LEMUR     ' TO ARG2 END-IF
            IF ARG1 = 'M' MOVE 'MACAW     ' TO ARG2 END-IF
            IF ARG1 = 'N' MOVE 'NEWT      ' TO ARG2 END-IF
            IF ARG1 = 'O' MOVE 'OCTOPUS   ' TO ARG2 END-IF
            IF ARG1 = 'P' MOVE 'PANTHER   ' TO ARG2 END-IF
            IF ARG1 = 'Q' MOVE 'QUAIL     ' TO ARG2 END-IF
            IF ARG1 = 'R' MOVE 'RABBIT    ' TO ARG2 END-IF
            IF ARG1 = 'S' MOVE 'SCORPION  ' TO ARG2 END-IF
            IF ARG1 = 'T' MOVE 'TIGER     ' TO ARG2 END-IF
            IF ARG1 = 'U' MOVE 'URCHIN    ' TO ARG2 END-IF
            IF ARG1 = 'V' MOVE 'VOLE      ' TO ARG2 END-IF
            IF ARG1 = 'W' MOVE 'WALRUS    ' TO ARG2 END-IF
            IF ARG1 = 'X' MOVE 'XERUS     ' TO ARG2 END-IF
            IF ARG1 = 'Y' MOVE 'YAK       ' TO ARG2 END-IF
            IF ARG1 = 'Z' MOVE 'ZEBRA     ' TO ARG2 END-IF
            GOBACK.
