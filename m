Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED77C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Mar 2022 23:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiCUXKQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Mar 2022 19:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbiCUXJ3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Mar 2022 19:09:29 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0214152C9
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Mar 2022 16:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1647903557;
        bh=NlCY1coQaeyF1EQVQ4agYbz4odi+P7Gb4yklmJjO7Hg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Fc3GKOVmz0aMKloQdfFiTJeT4gugFS69ycFzfMXisxm2gORTuX0KvTDy4fklMcOoB
         gs9WJS02W5SfYE7uT1H4M2ahQ4rQSYCXUy0VS/OVX+IAv0NyOTwH0WgCOZGcj1/aCp
         Yh2ZMWZOrWUF5je14J18YDABBtTYElyr2bcH0zCU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from madeye.fritz.box ([37.4.228.18]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M5fIQ-1nQPIp3wPy-007BNV; Mon, 21
 Mar 2022 23:54:02 +0100
From:   Nicolas Fella <nicolas.fella@gmx.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Nicolas Fella <nicolas.fella@gmx.de>
Subject: [PATCH] kernelshark: Set QApplication::desktopFileName
Date:   Mon, 21 Mar 2022 23:53:30 +0100
Message-Id: <20220321225330.825082-1-nicolas.fella@gmx.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EZQctLfDS7qHwQUgelsVrDgDafu+59LkrtdvIrRQVWkY1wGEVv8
 fR+Y3bGZQz9Vcg1UfLyRTZ+cpbIHBj0iND9tYXD2C5+xcNy+1Y3WxYtzKlXKCtYQn8zBahL
 Uw6+xzRqFLP0iT476pPr/zxSD706xTzVZmRXeARl+oFSDa3WEurS6IEQjLeigwcYCPlTmPh
 /1vw6hhFf4sm45YjCHJ2A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bM4tNq2Iy8k=:KZSiyo75Wo2d/A9WiFjo/W
 7f9LmKurzDsNHBi/fW++T/YDB5+/44ECG8M1n2GrsbZieReyglyV0YhBdpMIYVy4OD1ANvWPF
 HpGE4RgUMLtc0T+JoHbpYkBl9hk1n+ZA9CnvTKiVQk+S29yAWE5xLuzVpNUruXlD5ffyoUZXU
 sWf7+Plw76dh+GbCeWAVWpR1cqAlBw4n03PLCAzfhShRguDcUfSD4Tr7K1tE137iGCJ4MjyHq
 yLUate/w4AWJvbICXuLoJLA8g2XqdhO+itgLZ3YC/nslKT9FwbulLAtRjA7vqLGf6XLHwomXw
 SbQkyI4uVMl5Srh4IaweFihaIKzkWq694NYwPn63OgXAty533Jrs/d0WqYlDRGtzhjIbDn6gD
 +AtuWDiLlrjWlje8ejoDYI2suOXHP/KSlUUEC3kTM5vuNvt3hetsSed38zojrh8kBZBaGp9yO
 NECFxYLNuEY1iJafkcNTgVUbiGWd2RCkb2LLw9rNg4T5vGWoMNeyvw7VbgglAvX6Klgpi/mN8
 rUoWngoWLzc2dj+WKH7Y7UPhk2/sMNFceX/bcvElnFSVqdTa3yBPVlFUl7vjL+qqLScjYANJP
 YyYT0iFLbFbThoyWuP/yrZMI69q2EfNmKj0KO2zF6NWDdTQBbB2ue83ETWLu4s/NvIqi7/K+D
 F5MGkxNJIAttkXwcml4x1+yzCUN9LdcDEl8Eh9WZGEYadWiucDZgbg2NxJISbjUuMij7hfaoK
 CVGl9U6Nh4bG4/PJgPW05K3AKKPVSiFze0ie81TT55jkH0g8ILiGV5TeyQseLmCmrN56rQd+u
 RCfvQ9OEPV15YHS1gj6gV1OQxi/M49RzZOHlfo8tlswr+oRZZ7jiWvORJETKPx9gkSxrCkNxf
 mWxkVV5NxUmORu/8B5u2rXcHdpV1TZSS7y7LZ1Z+7atLbkspbEyXzL2rBLRrMD9YQi1YY9Vi3
 fxZ623c5z/8MHRarB/qVNKkH1EnshOKolGZT7rj9QVpdvNqpaBSAQ4J9ICaJuEWhksmgG3mff
 OC+DQ2O9OPlqKJSSarhDBIxhxKtdupSDWfaa3R7r32qd3Z6INdY7DW3OwZ2GsST8loEwNiqBt
 SDvdMtLtrLU86M=
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is needed for properly associating the window with the desktop file.

This is needed for e.g. showing the correct icon in desktop environments.

Signed-off-by: Nicolas Fella <nicolas.fella@gmx.de>
=2D--
 src/kernelshark.cpp | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/kernelshark.cpp b/src/kernelshark.cpp
index 92bc1f1..c373f54 100644
=2D-- a/src/kernelshark.cpp
+++ b/src/kernelshark.cpp
@@ -56,6 +56,7 @@ int main(int argc, char **argv)
 	int c;

 	QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
+	QApplication::setDesktopFileName("kernelshark");
 	QApplication a(argc, argv);

 	KsMainWindow ks;
=2D-
2.35.1

