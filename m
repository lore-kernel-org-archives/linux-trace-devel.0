Return-Path: <SRS0=5Z96=UG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 095C7C468BC
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jun 2019 09:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4ECD2146E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 Jun 2019 09:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfFGJvU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 Jun 2019 05:51:20 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:36979 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727246AbfFGJvU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 05:51:20 -0400
Received: by mail-wr1-f45.google.com with SMTP id v14so1493482wrr.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 Jun 2019 02:51:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GL/GNTISHdFJix+Gy2JrNNxjN2/MI7t7oiyOJgc1ojM=;
        b=sGcPNMSTHnfOOxkrUhNdClRvWvBbgL62K7FphbCMIb6mOMyYqMrlsQzqGiefRZfWfz
         BkhO81W21/OA6fPVK42QfpGG5QguhcuawQMYEIYwdXrTCnUyLy6TSznI1AtWcapjIxSy
         61OV+74u12QTa0aTZhVil10REFqjtLF3FzMQN5y3HCJxlDDEcYw22gW13uVnOqdG/n+b
         AEXgJY1kd2glTi/KFuqn9Y7EbUzOzszL3sU6GHjxML4yKNM2Vdm6bBuVFKqrd+a09ZTh
         MWgvZ5t3G9KRGib87uxzlmmO2PpWfTzR9ZCLxlxOgyeDqX3GFcz0PHQmpgqMaVzngA5m
         n/tw==
X-Gm-Message-State: APjAAAXkncvdmiVeCsT6c6dHmB9V3YxxXzXTH1bekCejkQjUGQKsJy7s
        IfhyvXD2TqL+VLFB8s+re2hBs+HR
X-Google-Smtp-Source: APXvYqw6F6I5kV+31ST4N8JtPOYjpch7oxeQZXY7kQhajqouR8F4w9D2iugeqrWtnX3GjdHnv9kbDg==
X-Received: by 2002:adf:bac5:: with SMTP id w5mr20877010wrg.124.1559901075022;
        Fri, 07 Jun 2019 02:51:15 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y5sm1606974wrs.63.2019.06.07.02.51.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 02:51:14 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        sstamenkova@vmware.com, Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/3] kernel-shark: Add logo and icon files
Date:   Fri,  7 Jun 2019 12:50:54 +0300
Message-Id: <20190607095056.14666-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607095056.14666-1-ykaradzhov@vmware.com>
References: <20190607095056.14666-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All graphics files of the KernelShark's logos and icons have been
contributed to the project by Stela Stamenkova. This artistic work
can be used under the terms of the Creative Commons (BY) license.

Suggested-by: Stela Stamenkova <sstamenkova@vmware.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/icons/CC_BY-4.0              | 396 ++++++++++++++++++++++
 kernel-shark/icons/KS_icon_fin.svg        |   1 +
 kernel-shark/icons/KS_icon_shark.svg      |   1 +
 kernel-shark/icons/KS_logo_horizontal.svg |   1 +
 kernel-shark/icons/KS_logo_stacked.svg    |   1 +
 kernel-shark/icons/KS_logo_symbol.svg     |   1 +
 6 files changed, 401 insertions(+)
 create mode 100644 kernel-shark/icons/CC_BY-4.0
 create mode 100644 kernel-shark/icons/KS_icon_fin.svg
 create mode 100644 kernel-shark/icons/KS_icon_shark.svg
 create mode 100644 kernel-shark/icons/KS_logo_horizontal.svg
 create mode 100644 kernel-shark/icons/KS_logo_stacked.svg
 create mode 100644 kernel-shark/icons/KS_logo_symbol.svg

diff --git a/kernel-shark/icons/CC_BY-4.0 b/kernel-shark/icons/CC_BY-4.0
new file mode 100644
index 0000000..da6ab6c
--- /dev/null
+++ b/kernel-shark/icons/CC_BY-4.0
@@ -0,0 +1,396 @@
+Attribution 4.0 International
+
+=======================================================================
+
+Creative Commons Corporation ("Creative Commons") is not a law firm and
+does not provide legal services or legal advice. Distribution of
+Creative Commons public licenses does not create a lawyer-client or
+other relationship. Creative Commons makes its licenses and related
+information available on an "as-is" basis. Creative Commons gives no
+warranties regarding its licenses, any material licensed under their
+terms and conditions, or any related information. Creative Commons
+disclaims all liability for damages resulting from their use to the
+fullest extent possible.
+
+Using Creative Commons Public Licenses
+
+Creative Commons public licenses provide a standard set of terms and
+conditions that creators and other rights holders may use to share
+original works of authorship and other material subject to copyright
+and certain other rights specified in the public license below. The
+following considerations are for informational purposes only, are not
+exhaustive, and do not form part of our licenses.
+
+     Considerations for licensors: Our public licenses are
+     intended for use by those authorized to give the public
+     permission to use material in ways otherwise restricted by
+     copyright and certain other rights. Our licenses are
+     irrevocable. Licensors should read and understand the terms
+     and conditions of the license they choose before applying it.
+     Licensors should also secure all rights necessary before
+     applying our licenses so that the public can reuse the
+     material as expected. Licensors should clearly mark any
+     material not subject to the license. This includes other CC-
+     licensed material, or material used under an exception or
+     limitation to copyright. More considerations for licensors:
+    wiki.creativecommons.org/Considerations_for_licensors
+
+     Considerations for the public: By using one of our public
+     licenses, a licensor grants the public permission to use the
+     licensed material under specified terms and conditions. If
+     the licensor's permission is not necessary for any reason--for
+     example, because of any applicable exception or limitation to
+     copyright--then that use is not regulated by the license. Our
+     licenses grant only permissions under copyright and certain
+     other rights that a licensor has authority to grant. Use of
+     the licensed material may still be restricted for other
+     reasons, including because others have copyright or other
+     rights in the material. A licensor may make special requests,
+     such as asking that all changes be marked or described.
+     Although not required by our licenses, you are encouraged to
+     respect those requests where reasonable. More considerations
+     for the public:
+    wiki.creativecommons.org/Considerations_for_licensees
+
+=======================================================================
+
+Creative Commons Attribution 4.0 International Public License
+
+By exercising the Licensed Rights (defined below), You accept and agree
+to be bound by the terms and conditions of this Creative Commons
+Attribution 4.0 International Public License ("Public License"). To the
+extent this Public License may be interpreted as a contract, You are
+granted the Licensed Rights in consideration of Your acceptance of
+these terms and conditions, and the Licensor grants You such rights in
+consideration of benefits the Licensor receives from making the
+Licensed Material available under these terms and conditions.
+
+
+Section 1 -- Definitions.
+
+  a. Adapted Material means material subject to Copyright and Similar
+     Rights that is derived from or based upon the Licensed Material
+     and in which the Licensed Material is translated, altered,
+     arranged, transformed, or otherwise modified in a manner requiring
+     permission under the Copyright and Similar Rights held by the
+     Licensor. For purposes of this Public License, where the Licensed
+     Material is a musical work, performance, or sound recording,
+     Adapted Material is always produced where the Licensed Material is
+     synched in timed relation with a moving image.
+
+  b. Adapter's License means the license You apply to Your Copyright
+     and Similar Rights in Your contributions to Adapted Material in
+     accordance with the terms and conditions of this Public License.
+
+  c. Copyright and Similar Rights means copyright and/or similar rights
+     closely related to copyright including, without limitation,
+     performance, broadcast, sound recording, and Sui Generis Database
+     Rights, without regard to how the rights are labeled or
+     categorized. For purposes of this Public License, the rights
+     specified in Section 2(b)(1)-(2) are not Copyright and Similar
+     Rights.
+
+  d. Effective Technological Measures means those measures that, in the
+     absence of proper authority, may not be circumvented under laws
+     fulfilling obligations under Article 11 of the WIPO Copyright
+     Treaty adopted on December 20, 1996, and/or similar international
+     agreements.
+
+  e. Exceptions and Limitations means fair use, fair dealing, and/or
+     any other exception or limitation to Copyright and Similar Rights
+     that applies to Your use of the Licensed Material.
+
+  f. Licensed Material means the artistic or literary work, database,
+     or other material to which the Licensor applied this Public
+     License.
+
+  g. Licensed Rights means the rights granted to You subject to the
+     terms and conditions of this Public License, which are limited to
+     all Copyright and Similar Rights that apply to Your use of the
+     Licensed Material and that the Licensor has authority to license.
+
+  h. Licensor means the individual(s) or entity(ies) granting rights
+     under this Public License.
+
+  i. Share means to provide material to the public by any means or
+     process that requires permission under the Licensed Rights, such
+     as reproduction, public display, public performance, distribution,
+     dissemination, communication, or importation, and to make material
+     available to the public including in ways that members of the
+     public may access the material from a place and at a time
+     individually chosen by them.
+
+  j. Sui Generis Database Rights means rights other than copyright
+     resulting from Directive 96/9/EC of the European Parliament and of
+     the Council of 11 March 1996 on the legal protection of databases,
+     as amended and/or succeeded, as well as other essentially
+     equivalent rights anywhere in the world.
+
+  k. You means the individual or entity exercising the Licensed Rights
+     under this Public License. Your has a corresponding meaning.
+
+
+Section 2 -- Scope.
+
+  a. License grant.
+
+       1. Subject to the terms and conditions of this Public License,
+          the Licensor hereby grants You a worldwide, royalty-free,
+          non-sublicensable, non-exclusive, irrevocable license to
+          exercise the Licensed Rights in the Licensed Material to:
+
+            a. reproduce and Share the Licensed Material, in whole or
+               in part; and
+
+            b. produce, reproduce, and Share Adapted Material.
+
+       2. Exceptions and Limitations. For the avoidance of doubt, where
+          Exceptions and Limitations apply to Your use, this Public
+          License does not apply, and You do not need to comply with
+          its terms and conditions.
+
+       3. Term. The term of this Public License is specified in Section
+          6(a).
+
+       4. Media and formats; technical modifications allowed. The
+          Licensor authorizes You to exercise the Licensed Rights in
+          all media and formats whether now known or hereafter created,
+          and to make technical modifications necessary to do so. The
+          Licensor waives and/or agrees not to assert any right or
+          authority to forbid You from making technical modifications
+          necessary to exercise the Licensed Rights, including
+          technical modifications necessary to circumvent Effective
+          Technological Measures. For purposes of this Public License,
+          simply making modifications authorized by this Section 2(a)
+          (4) never produces Adapted Material.
+
+       5. Downstream recipients.
+
+            a. Offer from the Licensor -- Licensed Material. Every
+               recipient of the Licensed Material automatically
+               receives an offer from the Licensor to exercise the
+               Licensed Rights under the terms and conditions of this
+               Public License.
+
+            b. No downstream restrictions. You may not offer or impose
+               any additional or different terms or conditions on, or
+               apply any Effective Technological Measures to, the
+               Licensed Material if doing so restricts exercise of the
+               Licensed Rights by any recipient of the Licensed
+               Material.
+
+       6. No endorsement. Nothing in this Public License constitutes or
+          may be construed as permission to assert or imply that You
+          are, or that Your use of the Licensed Material is, connected
+          with, or sponsored, endorsed, or granted official status by,
+          the Licensor or others designated to receive attribution as
+          provided in Section 3(a)(1)(A)(i).
+
+  b. Other rights.
+
+       1. Moral rights, such as the right of integrity, are not
+          licensed under this Public License, nor are publicity,
+          privacy, and/or other similar personality rights; however, to
+          the extent possible, the Licensor waives and/or agrees not to
+          assert any such rights held by the Licensor to the limited
+          extent necessary to allow You to exercise the Licensed
+          Rights, but not otherwise.
+
+       2. Patent and trademark rights are not licensed under this
+          Public License.
+
+       3. To the extent possible, the Licensor waives any right to
+          collect royalties from You for the exercise of the Licensed
+          Rights, whether directly or through a collecting society
+          under any voluntary or waivable statutory or compulsory
+          licensing scheme. In all other cases the Licensor expressly
+          reserves any right to collect such royalties.
+
+
+Section 3 -- License Conditions.
+
+Your exercise of the Licensed Rights is expressly made subject to the
+following conditions.
+
+  a. Attribution.
+
+       1. If You Share the Licensed Material (including in modified
+          form), You must:
+
+            a. retain the following if it is supplied by the Licensor
+               with the Licensed Material:
+
+                 i. identification of the creator(s) of the Licensed
+                    Material and any others designated to receive
+                    attribution, in any reasonable manner requested by
+                    the Licensor (including by pseudonym if
+                    designated);
+
+                ii. a copyright notice;
+
+               iii. a notice that refers to this Public License;
+
+                iv. a notice that refers to the disclaimer of
+                    warranties;
+
+                 v. a URI or hyperlink to the Licensed Material to the
+                    extent reasonably practicable;
+
+            b. indicate if You modified the Licensed Material and
+               retain an indication of any previous modifications; and
+
+            c. indicate the Licensed Material is licensed under this
+               Public License, and include the text of, or the URI or
+               hyperlink to, this Public License.
+
+       2. You may satisfy the conditions in Section 3(a)(1) in any
+          reasonable manner based on the medium, means, and context in
+          which You Share the Licensed Material. For example, it may be
+          reasonable to satisfy the conditions by providing a URI or
+          hyperlink to a resource that includes the required
+          information.
+
+       3. If requested by the Licensor, You must remove any of the
+          information required by Section 3(a)(1)(A) to the extent
+          reasonably practicable.
+
+       4. If You Share Adapted Material You produce, the Adapter's
+          License You apply must not prevent recipients of the Adapted
+          Material from complying with this Public License.
+
+
+Section 4 -- Sui Generis Database Rights.
+
+Where the Licensed Rights include Sui Generis Database Rights that
+apply to Your use of the Licensed Material:
+
+  a. for the avoidance of doubt, Section 2(a)(1) grants You the right
+     to extract, reuse, reproduce, and Share all or a substantial
+     portion of the contents of the database;
+
+  b. if You include all or a substantial portion of the database
+     contents in a database in which You have Sui Generis Database
+     Rights, then the database in which You have Sui Generis Database
+     Rights (but not its individual contents) is Adapted Material; and
+
+  c. You must comply with the conditions in Section 3(a) if You Share
+     all or a substantial portion of the contents of the database.
+
+For the avoidance of doubt, this Section 4 supplements and does not
+replace Your obligations under this Public License where the Licensed
+Rights include other Copyright and Similar Rights.
+
+
+Section 5 -- Disclaimer of Warranties and Limitation of Liability.
+
+  a. UNLESS OTHERWISE SEPARATELY UNDERTAKEN BY THE LICENSOR, TO THE
+     EXTENT POSSIBLE, THE LICENSOR OFFERS THE LICENSED MATERIAL AS-IS
+     AND AS-AVAILABLE, AND MAKES NO REPRESENTATIONS OR WARRANTIES OF
+     ANY KIND CONCERNING THE LICENSED MATERIAL, WHETHER EXPRESS,
+     IMPLIED, STATUTORY, OR OTHER. THIS INCLUDES, WITHOUT LIMITATION,
+     WARRANTIES OF TITLE, MERCHANTABILITY, FITNESS FOR A PARTICULAR
+     PURPOSE, NON-INFRINGEMENT, ABSENCE OF LATENT OR OTHER DEFECTS,
+     ACCURACY, OR THE PRESENCE OR ABSENCE OF ERRORS, WHETHER OR NOT
+     KNOWN OR DISCOVERABLE. WHERE DISCLAIMERS OF WARRANTIES ARE NOT
+     ALLOWED IN FULL OR IN PART, THIS DISCLAIMER MAY NOT APPLY TO YOU.
+
+  b. TO THE EXTENT POSSIBLE, IN NO EVENT WILL THE LICENSOR BE LIABLE
+     TO YOU ON ANY LEGAL THEORY (INCLUDING, WITHOUT LIMITATION,
+     NEGLIGENCE) OR OTHERWISE FOR ANY DIRECT, SPECIAL, INDIRECT,
+     INCIDENTAL, CONSEQUENTIAL, PUNITIVE, EXEMPLARY, OR OTHER LOSSES,
+     COSTS, EXPENSES, OR DAMAGES ARISING OUT OF THIS PUBLIC LICENSE OR
+     USE OF THE LICENSED MATERIAL, EVEN IF THE LICENSOR HAS BEEN
+     ADVISED OF THE POSSIBILITY OF SUCH LOSSES, COSTS, EXPENSES, OR
+     DAMAGES. WHERE A LIMITATION OF LIABILITY IS NOT ALLOWED IN FULL OR
+     IN PART, THIS LIMITATION MAY NOT APPLY TO YOU.
+
+  c. The disclaimer of warranties and limitation of liability provided
+     above shall be interpreted in a manner that, to the extent
+     possible, most closely approximates an absolute disclaimer and
+     waiver of all liability.
+
+
+Section 6 -- Term and Termination.
+
+  a. This Public License applies for the term of the Copyright and
+     Similar Rights licensed here. However, if You fail to comply with
+     this Public License, then Your rights under this Public License
+     terminate automatically.
+
+  b. Where Your right to use the Licensed Material has terminated under
+     Section 6(a), it reinstates:
+
+       1. automatically as of the date the violation is cured, provided
+          it is cured within 30 days of Your discovery of the
+          violation; or
+
+       2. upon express reinstatement by the Licensor.
+
+     For the avoidance of doubt, this Section 6(b) does not affect any
+     right the Licensor may have to seek remedies for Your violations
+     of this Public License.
+
+  c. For the avoidance of doubt, the Licensor may also offer the
+     Licensed Material under separate terms or conditions or stop
+     distributing the Licensed Material at any time; however, doing so
+     will not terminate this Public License.
+
+  d. Sections 1, 5, 6, 7, and 8 survive termination of this Public
+     License.
+
+
+Section 7 -- Other Terms and Conditions.
+
+  a. The Licensor shall not be bound by any additional or different
+     terms or conditions communicated by You unless expressly agreed.
+
+  b. Any arrangements, understandings, or agreements regarding the
+     Licensed Material not stated herein are separate from and
+     independent of the terms and conditions of this Public License.
+
+
+Section 8 -- Interpretation.
+
+  a. For the avoidance of doubt, this Public License does not, and
+     shall not be interpreted to, reduce, limit, restrict, or impose
+     conditions on any use of the Licensed Material that could lawfully
+     be made without permission under this Public License.
+
+  b. To the extent possible, if any provision of this Public License is
+     deemed unenforceable, it shall be automatically reformed to the
+     minimum extent necessary to make it enforceable. If the provision
+     cannot be reformed, it shall be severed from this Public License
+     without affecting the enforceability of the remaining terms and
+     conditions.
+
+  c. No term or condition of this Public License will be waived and no
+     failure to comply consented to unless expressly agreed to by the
+     Licensor.
+
+  d. Nothing in this Public License constitutes or may be interpreted
+     as a limitation upon, or waiver of, any privileges and immunities
+     that apply to the Licensor or You, including from the legal
+     processes of any jurisdiction or authority.
+
+
+=======================================================================
+
+Creative Commons is not a party to its public
+licenses. Notwithstanding, Creative Commons may elect to apply one of
+its public licenses to material it publishes and in those instances
+will be considered the “Licensor.” The text of the Creative Commons
+public licenses is dedicated to the public domain under the CC0 Public
+Domain Dedication. Except for the limited purpose of indicating that
+material is shared under a Creative Commons public license or as
+otherwise permitted by the Creative Commons policies published at
+creativecommons.org/policies, Creative Commons does not authorize the
+use of the trademark "Creative Commons" or any other trademark or logo
+of Creative Commons without its prior written consent including,
+without limitation, in connection with any unauthorized modifications
+to any of its public licenses or any other arrangements,
+understandings, or agreements concerning use of licensed material. For
+the avoidance of doubt, this paragraph does not form part of the
+public licenses.
+
+Creative Commons may be contacted at creativecommons.org.
+
diff --git a/kernel-shark/icons/KS_icon_fin.svg b/kernel-shark/icons/KS_icon_fin.svg
new file mode 100644
index 0000000..eeec165
--- /dev/null
+++ b/kernel-shark/icons/KS_icon_fin.svg
@@ -0,0 +1 @@
+<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 36 36"><defs><style>.cls-1{fill:#add036;}.cls-2{fill:#0095d3;}</style></defs><title>KS</title><path class="cls-1" d="M33,19a1,1,0,0,0,0-2h-2.9V11.94H33a1,1,0,0,0,0-2h-3L26.06,6.08V3a1,1,0,0,0-2,0v2.9H19V3a1,1,0,0,0-2,0v2.9H12.13V3a1,1,0,1,0-2,0v2.9h0l-4,4H3a1,1,0,1,0,0,2h2.9V17H3a1,1,0,0,0,0,2h2.9v4.87H3a1,1,0,0,0,0,2h2.9v0l4.16,4.16h0V33a1,1,0,0,0,2,0v-2.9H17V33a1,1,0,0,0,2,0v-2.9h5.06V33a1,1,0,0,0,2,0v-3l4-4v0H33a1,1,0,0,0,0-2h-2.9V19Zm-4.9,6.08-3,3H10.92l-3-3V10.92l3-3H25.08l3,3Z"/><path class="cls-2" d="M27.22,22.83a3.05,3.05,0,0,0-2.48-1.52,2.42,2.42,0,0,0-1,.21c-4.61-3.43-4.05-9.15-4-9.4l.19-1.68-1.56.64c-6.63,2.7-7.24,7.59-7,10.23h-.05a3.06,3.06,0,0,0-2.49,1.52c-.42.57-.58.73-.88.73v2A3,3,0,0,0,10.38,24c.43-.57.59-.72.89-.72s.45.15.88.72a3,3,0,0,0,2.49,1.53A3,3,0,0,0,17.12,24c.43-.57.58-.72.88-.72s.46.15.89.72a3,3,0,0,0,2.48,1.53A3,3,0,0,0,23.85,24c.43-.57.59-.72.89-.7
 2s.45.15.88.72a3,3,0,0,0,2.48,1.53v-2C27.8,23.56,27.65,23.4,27.22,22.83Zm-5.85.73c-.3,0-.46-.16-.88-.73A3.07,3.07,0,0,0,18,21.31a3,3,0,0,0-2.48,1.52c-.43.57-.59.73-.88.73s-.46-.16-.89-.73l-.25-.33h0c-.08-.25-1.81-5.65,4.15-8.9a12.49,12.49,0,0,0,4.52,9.29C21.82,23.4,21.66,23.56,21.37,23.56Z"/></svg>
\ No newline at end of file
diff --git a/kernel-shark/icons/KS_icon_shark.svg b/kernel-shark/icons/KS_icon_shark.svg
new file mode 100644
index 0000000..9ec7548
--- /dev/null
+++ b/kernel-shark/icons/KS_icon_shark.svg
@@ -0,0 +1 @@
+<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" width="36" height="36" viewBox="0 0 36 36"><defs><style>.cls-1{fill:#add036;}.cls-2{fill:#0095d3;}</style></defs><title>KS</title><path class="cls-1" d="M4.61,9.94H3a1,1,0,1,0,0,2H5.19A16.78,16.78,0,0,1,4.61,9.94Z"/><path class="cls-1" d="M7.93,25.08V16.31a10.18,10.18,0,0,1-2-2.69V25.91l4.16,4.16H19v-2H10.92Z"/><path class="cls-2" d="M32,33a1,1,0,0,1-.74-.32l-3.64-4-3.65,4a1,1,0,0,1-1.1.26,1,1,0,0,1-.63-.94V28.71a6.44,6.44,0,0,1,2.85-5.36,6.09,6.09,0,0,0-5.23-4.41l-2.28,2.27a1,1,0,0,1-1.41,0,6.22,6.22,0,0,1-1.64-2.84A12,12,0,0,1,6,6.87a1,1,0,0,1,1-1h9.67A13,13,0,0,1,20,6.29a8.79,8.79,0,0,1,11.18,1,1,1,0,0,1,0,1.43L27.87,12A13.14,13.14,0,0,1,30,19.18v4.08a6.47,6.47,0,0,1,3,5.45V32a1,1,0,0,1-.64.94A1.13,1.13,0,0,1,32,33ZM27.59,26.2a1,1,0,0,1,.73.32L31,29.4v-.69a4.49,4.49,0,0,0-2.45-4,1,1,0,0,1-.55-.89V19.18a11.22,11.22,0,0,0-2.2-6.69,1,1,0,0,1,.09-1.3L29,8.09a6.77,6.77,0,0,0-8.2.08,1,1,0,0,1-.9.17,11.31,11.31,0,0
 ,0-3.2-.46H8a10,10,0,0,0,7.55,8.72,1,1,0,0,1,.75.81,4.23,4.23,0,0,0,.59,1.6l1.8-1.81a1,1,0,0,1,.74-.29,8.11,8.11,0,0,1,7.71,6.76,1,1,0,0,1-.53,1,4.48,4.48,0,0,0-2.44,4v.69l2.64-2.88A1,1,0,0,1,27.59,26.2Z"/><path class="cls-2" d="M9.42,14.55H9.33a1,1,0,0,1-.9-1.09,3.69,3.69,0,0,1,3.69-3.35H17.3a1,1,0,0,1,0,2H12.12a1.69,1.69,0,0,0-1.7,1.54A1,1,0,0,1,9.42,14.55Z"/><path class="cls-2" d="M22.66,9.47a1,1,0,0,1-.5-.13A11.24,11.24,0,0,0,16.6,7.87a1,1,0,1,1,0-2A13.28,13.28,0,0,1,23.15,7.6a1,1,0,0,1-.49,1.87Z"/><path class="cls-1" d="M33.33,24A5.92,5.92,0,0,1,34,25s0-.06,0-.1A1,1,0,0,0,33.33,24Z"/><path class="cls-1" d="M19,4.19V3a1,1,0,0,0-2,0V4A14.44,14.44,0,0,1,19,4.19Z"/><path class="cls-1" d="M26.06,3.29V3a1,1,0,0,0-2,0v.26A6.35,6.35,0,0,1,26.06,3.29Z"/><path class="cls-1" d="M12.13,4V3a1,1,0,1,0-2,0V4Z"/><path class="cls-1" d="M33,17H31.56v2H33a1,1,0,0,0,0-2Z"/><path class="cls-1" d="M32.37,9.94l-1.89,2H33a1,1,0,0,0,0-2Z"/><path class="cls-1" d="M18,28.33a1,1,0,0,0-1,1V33a1,1,0,0,0,2,0
 V29.33A1,1,0,0,0,18,28.33Z"/><path class="cls-1" d="M24.39,33.7a1,1,0,0,0,.67.27,1,1,0,0,0,1-1V32Z"/><path class="cls-1" d="M11.13,28.21a1,1,0,0,0-1,1V33a1,1,0,0,0,2,0V29.21A1,1,0,0,0,11.13,28.21Z"/><path class="cls-1" d="M6.84,17H3a1,1,0,0,0,0,2H6.84a1,1,0,0,0,0-2Z"/><path class="cls-1" d="M6.34,23.87H3a1,1,0,0,0,0,2H6.34a1,1,0,0,0,0-2Z"/></svg>
\ No newline at end of file
diff --git a/kernel-shark/icons/KS_logo_horizontal.svg b/kernel-shark/icons/KS_logo_horizontal.svg
new file mode 100644
index 0000000..7ffce3d
--- /dev/null
+++ b/kernel-shark/icons/KS_logo_horizontal.svg
@@ -0,0 +1 @@
+<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" width="668" height="255" viewBox="0 0 668 255"><defs><style>.cls-1{fill:#61717d;}.cls-2{fill:#add036;}.cls-3{fill:#0095d3;}</style></defs><title>KS</title><path class="cls-1" d="M254.91,111.33h7V126.4l13.29-15.07h8.57L271,125.59l13.73,18.61h-8.57l-10.09-13.59L262,135v9.19h-7Z"/><path class="cls-1" d="M295.19,117.69v6.56h16.5v6.36h-16.5v7.22h18.22v6.37h-25.3V111.33h25.3v6.36Z"/><path class="cls-1" d="M338.52,144.2,331,133.53H325.8V144.2h-7V111.33h14.78c7.12,0,12.39,4.59,12.39,11.1a10.68,10.68,0,0,1-7.47,10.28l8.09,11.49ZM325.8,127.07h7c3.49,0,5.89-1.82,5.89-4.64s-2.4-4.64-5.89-4.64h-7Z"/><path class="cls-1" d="M351.48,111.33h7l15.84,21.24V111.33h7.08V144.2h-7.08L358.51,123V144.2h-7Z"/><path class="cls-1" d="M395.29,117.69v6.56H411.8v6.36H395.29v7.22h18.23v6.37H388.21V111.33h25.31v6.36Z"/><path class="cls-1" d="M442.07,137.83v6.37H418.63V111.33h7.08v26.5Z"/><path class="cls-1" d="M444.46,139.32l4.07-4.84a16.19,16
 .19,0,0,0,10.81,4.31c3.54,0,5.35-1.63,5.35-3.68,0-2.35-1.91-3.07-6.93-4.21-6.94-1.58-11.87-3.54-11.87-9.9,0-6.08,5-10.24,12.15-10.24a19,19,0,0,1,12.87,4.54l-3.68,5.07a15.26,15.26,0,0,0-9.38-3.63c-3,0-4.83,1.58-4.83,3.54,0,2.39,2,3.15,7,4.3,7.08,1.58,11.77,3.69,11.77,9.76,0,6.27-4.73,10.43-12.77,10.43A21.11,21.11,0,0,1,444.46,139.32Z"/><path class="cls-1" d="M505.92,111.33V144.2h-7V130.61h-15V144.2h-7V111.33h7v12.92h15V111.33Z"/><path class="cls-1" d="M534.43,139H519.79l-2.1,5.17h-7.9l13.4-32.87h7.89l13.4,32.87h-7.94Zm-2.44-6-4.88-12-4.88,12Z"/><path class="cls-1" d="M568.1,144.2l-7.51-10.67h-5.21V144.2h-7V111.33h14.78c7.12,0,12.39,4.59,12.39,11.1a10.68,10.68,0,0,1-7.47,10.28l8.09,11.49Zm-12.72-17.13h7c3.49,0,5.89-1.82,5.89-4.64s-2.4-4.64-5.89-4.64h-7Z"/><path class="cls-1" d="M581,111.33h7V126.4l13.3-15.07h8.57l-12.82,14.26,13.72,18.61h-8.56l-10.09-13.59L588,135v9.19h-7Z"/><path class="cls-2" d="M108.38,127.29a3.14,3.14,0,0,1-3.14-3.14V117a3.14,3.14,0,0,1,6.27,0v7.11A3.13,3.13,0,0,1
 ,108.38,127.29Z"/><path class="cls-2" d="M96.87,147.94a3.13,3.13,0,0,1-3.13-3.13v-7.12a3.14,3.14,0,0,1,6.27,0v7.12A3.13,3.13,0,0,1,96.87,147.94Z"/><path class="cls-2" d="M109.3,162.18a3.14,3.14,0,0,1-3.13-3.14v-3.88a3.14,3.14,0,1,1,6.27,0V159A3.14,3.14,0,0,1,109.3,162.18Z"/><path class="cls-2" d="M152.29,146.8a3.15,3.15,0,0,1-3.14-3.14v-9.55a3.14,3.14,0,1,1,6.28,0v9.55A3.15,3.15,0,0,1,152.29,146.8Z"/><path class="cls-2" d="M144.83,178.74a3.13,3.13,0,0,1-3.14-3.13v-7.38a3.14,3.14,0,0,1,6.27,0v7.38A3.13,3.13,0,0,1,144.83,178.74Z"/><path class="cls-2" d="M123.34,148.74a3.14,3.14,0,0,1-3.14-3.14v-6.78a3.14,3.14,0,0,1,6.28,0v6.78A3.14,3.14,0,0,1,123.34,148.74Z"/><path class="cls-2" d="M123.34,180a3.15,3.15,0,0,1-3.14-3.14V161.12a3.14,3.14,0,1,1,6.28,0v15.74A3.15,3.15,0,0,1,123.34,180Z"/><path class="cls-2" d="M138.06,155.42a3.14,3.14,0,0,1-3.14-3.13v-3.72a3.14,3.14,0,0,1,6.28,0v3.72A3.14,3.14,0,0,1,138.06,155.42Z"/><path class="cls-3" d="M202.28,193a3.14,3.14,0,0,1-2.31-1l-18.7-20.34L162
 .58,192a3.14,3.14,0,0,1-5.45-2.12V174.3a29.4,29.4,0,0,1,14-25.07,31,31,0,0,0-27.63-23.54L132,137.18a3.15,3.15,0,0,1-4.39,0l-.06-.05a28.55,28.55,0,0,1-7.67-13.73A55.68,55.68,0,0,1,79.41,69.6a3.19,3.19,0,0,1,.92-2.21,3.15,3.15,0,0,1,2.23-.92h46.36A62.38,62.38,0,0,1,145,68.58a40.43,40.43,0,0,1,52.07,4.28l.12.13a3.13,3.13,0,0,1,0,4.39L180.53,94a61.6,61.6,0,0,1,10.52,34.59V149a29.39,29.39,0,0,1,14.36,25.31v15.6a3.15,3.15,0,0,1-2,2.92A3.24,3.24,0,0,1,202.28,193Zm-21-29.12a3.15,3.15,0,0,1,2.31,1l15.56,16.93V174.3a23.15,23.15,0,0,0-12.65-20.67,3.13,3.13,0,0,1-1.71-2.79V128.6a55.46,55.46,0,0,0-10.86-33.09,3.12,3.12,0,0,1,.31-4.07l16.18-16.18a34.14,34.14,0,0,0-42.84-.76,3.14,3.14,0,0,1-2.82.53,55.92,55.92,0,0,0-15.83-2.29H85.78a49.37,49.37,0,0,0,37.54,45.12,3.14,3.14,0,0,1,2.35,2.55,22.17,22.17,0,0,0,4.25,10L140,120.27a3.15,3.15,0,0,1,2.32-.92,37.28,37.28,0,0,1,35.37,31,3.12,3.12,0,0,1-1.66,3.31A23.14,23.14,0,0,0,163.4,174.3v7.55L179,164.92A3.14,3.14,0,0,1,181.27,163.91Z"/><path class="cls-3"
  d="M94.13,106A3.14,3.14,0,0,1,91,102.88a16.15,16.15,0,0,1,16.13-16.12H132A3.14,3.14,0,0,1,132,93H107.12a9.86,9.86,0,0,0-9.85,9.85A3.14,3.14,0,0,1,94.13,106Z"/><path class="cls-3" d="M157.64,80.38A3.09,3.09,0,0,1,156.1,80a55.9,55.9,0,0,0-27.51-7.23,3.14,3.14,0,1,1,0-6.27,62.21,62.21,0,0,1,30.6,8,3.14,3.14,0,0,1-1.55,5.87Z"/><path class="cls-2" d="M181.87,185.51h-7.38l-6.27,6.28h14.95a3.18,3.18,0,0,0,2.22-.92l5-5-4.26-4.62Z"/><path class="cls-2" d="M85.61,168v-62.2a53,53,0,0,1-6.27-12v75.48a3.12,3.12,0,0,0,.92,2.22l19.35,19.36a3.18,3.18,0,0,0,2.22.92h52.09v-6.28H103.13Z"/><path class="cls-2" d="M204.74,85.74l-3.69-3.69-4.44,4.43,2.78,2.78v.17h.09v62.12a50.08,50.08,0,0,1,6.19,6V88A3.12,3.12,0,0,0,204.74,85.74Z"/><path class="cls-2" d="M69.68,169.27h-9.5a3.14,3.14,0,0,1,0-6.28h9.5a3.14,3.14,0,0,1,0,6.28Z"/><path class="cls-2" d="M69.68,143.51h-9.5a3.14,3.14,0,0,1,0-6.27h9.5a3.14,3.14,0,0,1,0,6.27Z"/><path class="cls-2" d="M69.68,117.76h-9.5a3.14,3.14,0,0,1,0-6.27h9.5a3.14,3.14,0,0,1,0,
 6.27Z"/><path class="cls-2" d="M69.68,92h-9.5a3.14,3.14,0,0,1,0-6.28h9.5a3.14,3.14,0,0,1,0,6.28Z"/><path class="cls-2" d="M224.82,169.27h-9.5a3.14,3.14,0,0,1,0-6.28h9.5a3.14,3.14,0,0,1,0,6.28Z"/><path class="cls-2" d="M224.82,143.51h-9.5a3.14,3.14,0,0,1,0-6.27h9.5a3.14,3.14,0,0,1,0,6.27Z"/><path class="cls-2" d="M224.82,117.76h-9.5a3.14,3.14,0,0,1,0-6.27h9.5a3.14,3.14,0,0,1,0,6.27Z"/><path class="cls-2" d="M224.82,92h-9.5a3.14,3.14,0,0,1,0-6.28h9.5a3.14,3.14,0,0,1,0,6.28Z"/><path class="cls-2" d="M181.13,213a3.14,3.14,0,0,1-3.14-3.13v-9.5a3.14,3.14,0,0,1,6.28,0v9.5A3.14,3.14,0,0,1,181.13,213Z"/><path class="cls-2" d="M155.38,213a3.13,3.13,0,0,1-3.14-3.13v-9.5a3.14,3.14,0,0,1,6.27,0v9.5A3.13,3.13,0,0,1,155.38,213Z"/><path class="cls-2" d="M129.62,213a3.13,3.13,0,0,1-3.13-3.13v-9.5a3.14,3.14,0,0,1,6.27,0v9.5A3.13,3.13,0,0,1,129.62,213Z"/><path class="cls-2" d="M103.87,213a3.14,3.14,0,0,1-3.14-3.13v-9.5a3.14,3.14,0,0,1,6.28,0v9.5A3.14,3.14,0,0,1,103.87,213Z"/><path class="cls-2" d="M18
 1.13,57.81A3.14,3.14,0,0,1,178,54.68v-9.5a3.14,3.14,0,0,1,6.28,0v9.5A3.14,3.14,0,0,1,181.13,57.81Z"/><path class="cls-2" d="M155.38,57.81a3.13,3.13,0,0,1-3.14-3.13v-9.5a3.14,3.14,0,0,1,6.27,0v9.5A3.13,3.13,0,0,1,155.38,57.81Z"/><path class="cls-2" d="M129.62,57.81a3.13,3.13,0,0,1-3.13-3.13v-9.5a3.14,3.14,0,0,1,6.27,0v9.5A3.13,3.13,0,0,1,129.62,57.81Z"/><path class="cls-2" d="M103.87,57.81a3.14,3.14,0,0,1-3.14-3.13v-9.5a3.14,3.14,0,0,1,6.28,0v9.5A3.14,3.14,0,0,1,103.87,57.81Z"/><path class="cls-3" d="M131.52,82.83h-8a3.14,3.14,0,1,1,0-6.28h8a3.14,3.14,0,0,1,0,6.28Z"/></svg>
\ No newline at end of file
diff --git a/kernel-shark/icons/KS_logo_stacked.svg b/kernel-shark/icons/KS_logo_stacked.svg
new file mode 100644
index 0000000..10e6fd8
--- /dev/null
+++ b/kernel-shark/icons/KS_logo_stacked.svg
@@ -0,0 +1 @@
+<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" width="172" height="205" viewBox="0 0 172 205"><defs><style>.cls-1{fill:#add036;}.cls-2{fill:#0095d3;}.cls-3{fill:#61717d;}</style></defs><title>KS</title><path class="cls-1" d="M62.66,92.33a2.15,2.15,0,0,1-2.15-2.15V85.32a2.15,2.15,0,1,1,4.29,0v4.86A2.14,2.14,0,0,1,62.66,92.33Z"/><path class="cls-1" d="M54.79,106.46a2.16,2.16,0,0,1-2.15-2.15V99.45a2.15,2.15,0,1,1,4.3,0v4.86A2.15,2.15,0,0,1,54.79,106.46Z"/><path class="cls-1" d="M63.29,116.19a2.14,2.14,0,0,1-2.14-2.14v-2.66a2.15,2.15,0,0,1,4.29,0v2.66A2.14,2.14,0,0,1,63.29,116.19Z"/><path class="cls-1" d="M92.7,105.67a2.14,2.14,0,0,1-2.15-2.14V97a2.15,2.15,0,0,1,4.29,0v6.54A2.14,2.14,0,0,1,92.7,105.67Z"/><path class="cls-1" d="M87.59,127.52a2.14,2.14,0,0,1-2.14-2.14v-5a2.15,2.15,0,0,1,4.29,0v5A2.14,2.14,0,0,1,87.59,127.52Z"/><path class="cls-1" d="M72.89,107a2.14,2.14,0,0,1-2.14-2.14v-4.65a2.15,2.15,0,0,1,4.29,0v4.65A2.14,2.14,0,0,1,72.89,107Z"/><path class="cl
 s-1" d="M72.89,128.38a2.14,2.14,0,0,1-2.14-2.14V115.47a2.15,2.15,0,1,1,4.29,0v10.77A2.14,2.14,0,0,1,72.89,128.38Z"/><path class="cls-1" d="M83,111.57a2.14,2.14,0,0,1-2.14-2.14v-2.55a2.15,2.15,0,0,1,4.29,0v2.55A2.14,2.14,0,0,1,83,111.57Z"/><path class="cls-2" d="M126.89,137.3a2.13,2.13,0,0,1-1.58-.7l-12.79-13.91L99.73,136.6A2.14,2.14,0,0,1,96,135.15V124.49a20.1,20.1,0,0,1,9.55-17.15,21.21,21.21,0,0,0-18.9-16.1l-7.85,7.85a2.14,2.14,0,0,1-3,0l0,0a19.43,19.43,0,0,1-5.25-9.39A38.07,38.07,0,0,1,42.85,52.86a2.11,2.11,0,0,1,.63-1.51A2.16,2.16,0,0,1,45,50.72H76.71a42.6,42.6,0,0,1,11,1.45,27.66,27.66,0,0,1,35.62,2.93l.08.08a2.15,2.15,0,0,1,0,3L112,69.56a42.1,42.1,0,0,1,7.2,23.66v14A20.09,20.09,0,0,1,129,124.49v10.66a2.16,2.16,0,0,1-2.15,2.15Zm-14.37-19.92a2.14,2.14,0,0,1,1.58.69l10.65,11.58v-5.16a15.82,15.82,0,0,0-8.66-14.14,2.15,2.15,0,0,1-1.17-1.91V93.22a37.9,37.9,0,0,0-7.43-22.63,2.15,2.15,0,0,1,.21-2.79l11.07-11.06a23.35,23.35,0,0,0-29.3-.53,2.13,2.13,0,0,1-1.93.37A38.24,38.24,0,0,0,76.71
 ,55H47.2A33.77,33.77,0,0,0,72.88,85.88a2.15,2.15,0,0,1,1.61,1.74,15.17,15.17,0,0,0,2.9,6.82l6.92-6.92a2.15,2.15,0,0,1,1.59-.62,25.49,25.49,0,0,1,24.19,21.18,2.15,2.15,0,0,1-1.13,2.27,15.82,15.82,0,0,0-8.66,14.14v5.16l10.64-11.58A2.16,2.16,0,0,1,112.52,117.38Z"/><path class="cls-2" d="M52.91,77.78a2.14,2.14,0,0,1-2.14-2.15,11,11,0,0,1,11-11h17a2.15,2.15,0,1,1,0,4.29h-17a6.75,6.75,0,0,0-6.74,6.74A2.15,2.15,0,0,1,52.91,77.78Z"/><path class="cls-2" d="M96.36,60.24A2.16,2.16,0,0,1,95.3,60a38.17,38.17,0,0,0-18.82-5,2.15,2.15,0,0,1,0-4.29,42.43,42.43,0,0,1,20.94,5.51,2.14,2.14,0,0,1-1.06,4Z"/><path class="cls-1" d="M112.93,132.15h-5l-4.3,4.3h10.23a2.18,2.18,0,0,0,1.52-.63l3.38-3.39-2.91-3.16Z"/><path class="cls-1" d="M47.09,120.17V77.62a36.09,36.09,0,0,1-4.29-8.19v51.63a2.15,2.15,0,0,0,.62,1.52l13.24,13.24a2.18,2.18,0,0,0,1.52.63H93.81v-4.3H59.07Z"/><path class="cls-1" d="M128.58,63.91l-2.53-2.53-3,3,1.9,1.9v.12H125v42.49A33.64,33.64,0,0,1,129.2,113V65.42A2.13,2.13,0,0,0,128.58,63.91Z"/><p
 ath class="cls-1" d="M36.19,121h-6.5a2.15,2.15,0,0,1,0-4.29h6.5a2.15,2.15,0,0,1,0,4.29Z"/><path class="cls-1" d="M36.19,103.43h-6.5a2.15,2.15,0,0,1,0-4.3h6.5a2.15,2.15,0,0,1,0,4.3Z"/><path class="cls-1" d="M36.19,85.81h-6.5a2.15,2.15,0,0,1,0-4.29h6.5a2.15,2.15,0,0,1,0,4.29Z"/><path class="cls-1" d="M36.19,68.19h-6.5a2.15,2.15,0,0,1,0-4.29h6.5a2.15,2.15,0,0,1,0,4.29Z"/><path class="cls-1" d="M142.31,121h-6.5a2.15,2.15,0,0,1,0-4.29h6.5a2.15,2.15,0,0,1,0,4.29Z"/><path class="cls-1" d="M142.31,103.43h-6.5a2.15,2.15,0,0,1,0-4.3h6.5a2.15,2.15,0,0,1,0,4.3Z"/><path class="cls-1" d="M142.31,85.81h-6.5a2.15,2.15,0,0,1,0-4.29h6.5a2.15,2.15,0,0,1,0,4.29Z"/><path class="cls-1" d="M142.31,68.19h-6.5a2.15,2.15,0,0,1,0-4.29h6.5a2.15,2.15,0,0,1,0,4.29Z"/><path class="cls-1" d="M112.42,150.93a2.15,2.15,0,0,1-2.14-2.15v-6.49a2.15,2.15,0,1,1,4.29,0v6.49A2.15,2.15,0,0,1,112.42,150.93Z"/><path class="cls-1" d="M94.81,150.93a2.15,2.15,0,0,1-2.15-2.15v-6.49a2.15,2.15,0,1,1,4.29,0v6.49A2.15,2.15,0,0,1,94.81
 ,150.93Z"/><path class="cls-1" d="M77.19,150.93a2.15,2.15,0,0,1-2.14-2.15v-6.49a2.15,2.15,0,1,1,4.29,0v6.49A2.15,2.15,0,0,1,77.19,150.93Z"/><path class="cls-1" d="M59.58,150.93a2.15,2.15,0,0,1-2.15-2.15v-6.49a2.15,2.15,0,1,1,4.29,0v6.49A2.15,2.15,0,0,1,59.58,150.93Z"/><path class="cls-1" d="M112.42,44.8a2.14,2.14,0,0,1-2.14-2.14v-6.5a2.15,2.15,0,0,1,4.29,0v6.5A2.14,2.14,0,0,1,112.42,44.8Z"/><path class="cls-1" d="M94.81,44.8a2.14,2.14,0,0,1-2.15-2.14v-6.5a2.15,2.15,0,0,1,4.29,0v6.5A2.14,2.14,0,0,1,94.81,44.8Z"/><path class="cls-1" d="M77.19,44.8a2.14,2.14,0,0,1-2.14-2.14v-6.5a2.15,2.15,0,0,1,4.29,0v6.5A2.14,2.14,0,0,1,77.19,44.8Z"/><path class="cls-1" d="M59.58,44.8a2.14,2.14,0,0,1-2.15-2.14v-6.5a2.15,2.15,0,0,1,4.29,0v6.5A2.14,2.14,0,0,1,59.58,44.8Z"/><path class="cls-2" d="M78.49,61.91H73a2.15,2.15,0,1,1,0-4.29h5.45a2.15,2.15,0,1,1,0,4.29Z"/><path class="cls-3" d="M40.87,162.55h1.77v3.8l3.36-3.8h2.16l-3.24,3.59,3.47,4.7H46.23l-2.55-3.43-1,1.11v2.32H40.87Z"/><path class="cls-3" d="
 M51,164.15v1.65H55.2v1.61H51v1.82h4.6v1.61H49.25v-8.29h6.38v1.6Z"/><path class="cls-3" d="M62,170.84l-1.89-2.69H58.76v2.69H57v-8.29h3.73a2.87,2.87,0,0,1,3.12,2.8A2.7,2.7,0,0,1,62,167.94l2,2.9Zm-3.21-4.32h1.76c.88,0,1.49-.46,1.49-1.17s-.61-1.17-1.49-1.17H58.76Z"/><path class="cls-3" d="M65.25,162.55H67l4,5.36v-5.36H72.8v8.29H71l-4-5.36v5.36H65.25Z"/><path class="cls-3" d="M76.31,164.15v1.65h4.16v1.61H76.31v1.82H80.9v1.61H74.52v-8.29H80.9v1.6Z"/><path class="cls-3" d="M88.11,169.23v1.61H82.2v-8.29H84v6.68Z"/><path class="cls-3" d="M88.72,169.61l1-1.22a4.09,4.09,0,0,0,2.72,1.08c.9,0,1.35-.41,1.35-.93s-.48-.77-1.75-1.06c-1.75-.4-3-.89-3-2.5s1.26-2.58,3.07-2.58a4.74,4.74,0,0,1,3.24,1.15l-.93,1.28a3.82,3.82,0,0,0-2.36-.92c-.76,0-1.22.4-1.22.89s.49.8,1.77,1.09c1.79.4,3,.93,3,2.46S94.43,171,92.4,171A5.32,5.32,0,0,1,88.72,169.61Z"/><path class="cls-3" d="M104.23,162.55v8.29h-1.77v-3.43H98.68v3.43H96.9v-8.29h1.78v3.25h3.78v-3.25Z"/><path class="cls-3" d="M111.43,169.53h-3.69l-.54,1.31h-2l3.38
 -8.29h2l3.38,8.29h-2Zm-.62-1.5-1.23-3-1.23,3Z"/><path class="cls-3" d="M119.93,170.84l-1.9-2.69h-1.31v2.69h-1.78v-8.29h3.73a2.87,2.87,0,0,1,3.13,2.8,2.7,2.7,0,0,1-1.88,2.59l2,2.9Zm-3.21-4.32h1.76c.88,0,1.49-.46,1.49-1.17s-.61-1.17-1.49-1.17h-1.76Z"/><path class="cls-3" d="M123.19,162.55H125v3.8l3.35-3.8h2.16l-3.23,3.59,3.46,4.7h-2.16L126,167.41l-1,1.11v2.32h-1.78Z"/></svg>
\ No newline at end of file
diff --git a/kernel-shark/icons/KS_logo_symbol.svg b/kernel-shark/icons/KS_logo_symbol.svg
new file mode 100644
index 0000000..4bf0340
--- /dev/null
+++ b/kernel-shark/icons/KS_logo_symbol.svg
@@ -0,0 +1 @@
+<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" width="200" height="200" viewBox="0 0 200 200"><defs><style>.cls-1{fill:#add036;}.cls-2{fill:#0095d3;}</style></defs><title>KS</title><path class="cls-1" d="M60.07,99.76a3.67,3.67,0,0,1-3.67-3.68V87.76a3.67,3.67,0,0,1,7.34,0v8.32A3.67,3.67,0,0,1,60.07,99.76Z"/><path class="cls-1" d="M46.61,123.92a3.67,3.67,0,0,1-3.67-3.67v-8.32a3.67,3.67,0,1,1,7.34,0v8.32A3.67,3.67,0,0,1,46.61,123.92Z"/><path class="cls-1" d="M61.15,140.58a3.67,3.67,0,0,1-3.67-3.67v-4.54a3.67,3.67,0,1,1,7.34,0v4.54A3.67,3.67,0,0,1,61.15,140.58Z"/><path class="cls-1" d="M111.46,122.58a3.67,3.67,0,0,1-3.67-3.67V107.74a3.67,3.67,0,1,1,7.34,0v11.17A3.67,3.67,0,0,1,111.46,122.58Z"/><path class="cls-1" d="M102.72,160a3.68,3.68,0,0,1-3.67-3.67v-8.63a3.67,3.67,0,0,1,7.34,0v8.63A3.67,3.67,0,0,1,102.72,160Z"/><path class="cls-1" d="M77.58,124.86a3.67,3.67,0,0,1-3.67-3.67v-8a3.67,3.67,0,0,1,7.34,0v8A3.68,3.68,0,0,1,77.58,124.86Z"/><path class="cls-1" d="M
 77.58,161.43a3.67,3.67,0,0,1-3.67-3.67V139.34a3.67,3.67,0,1,1,7.34,0v18.42A3.67,3.67,0,0,1,77.58,161.43Z"/><path class="cls-1" d="M94.8,132.68A3.68,3.68,0,0,1,91.13,129v-4.35a3.68,3.68,0,1,1,7.35,0V129A3.68,3.68,0,0,1,94.8,132.68Z"/><path class="cls-2" d="M170,176.69a3.65,3.65,0,0,1-2.7-1.19l-21.89-23.8-21.88,23.8a3.67,3.67,0,0,1-6.37-2.48V154.77a34.39,34.39,0,0,1,16.35-29.34,36.29,36.29,0,0,0-32.33-27.54L87.7,111.32a3.67,3.67,0,0,1-5.14.06l-.07-.07a33.36,33.36,0,0,1-9-16.07,65.12,65.12,0,0,1-47.34-63,3.67,3.67,0,0,1,3.67-3.66H84.11a73,73,0,0,1,18.82,2.47,47.31,47.31,0,0,1,60.93,5l.14.15a3.67,3.67,0,0,1,0,5.14L144.51,60.81a72.13,72.13,0,0,1,12.31,40.48v23.86a34.4,34.4,0,0,1,16.81,29.62V173a3.68,3.68,0,0,1-2.34,3.42A3.61,3.61,0,0,1,170,176.69Zm-24.59-34.08a3.71,3.71,0,0,1,2.71,1.18l18.21,19.81v-8.83a27.09,27.09,0,0,0-14.81-24.19,3.67,3.67,0,0,1-2-3.27v-26a64.86,64.86,0,0,0-12.71-38.72,3.67,3.67,0,0,1,.36-4.77l18.93-18.93a40,40,0,0,0-50.13-.9,3.67,3.67,0,0,1-3.29.63,65.45,65.45,0,0,0-
 18.53-2.68H33.62a57.8,57.8,0,0,0,43.94,52.8,3.66,3.66,0,0,1,2.74,3,26.14,26.14,0,0,0,5,11.66L97.11,91.53a3.72,3.72,0,0,1,2.72-1.07,43.65,43.65,0,0,1,41.39,36.24,3.68,3.68,0,0,1-1.95,3.88,27.09,27.09,0,0,0-14.81,24.19v8.83l18.21-19.81A3.7,3.7,0,0,1,145.37,142.61Z"/><path class="cls-2" d="M43.39,74.86a3.67,3.67,0,0,1-3.67-3.67A18.9,18.9,0,0,1,58.6,52.32H87.65a3.67,3.67,0,0,1,0,7.34H58.6A11.55,11.55,0,0,0,47.07,71.19,3.67,3.67,0,0,1,43.39,74.86Z"/><path class="cls-2" d="M117.72,44.86a3.72,3.72,0,0,1-1.81-.48,65.3,65.3,0,0,0-32.19-8.46,3.67,3.67,0,0,1,0-7.34A72.71,72.71,0,0,1,119.53,38a3.67,3.67,0,0,1-1.81,6.87Z"/><path class="cls-1" d="M146.07,167.89h-8.63l-7.34,7.34h17.49a3.67,3.67,0,0,0,2.6-1.08l5.79-5.79L151,163Z"/><path class="cls-1" d="M33.43,147.39V74.59a62,62,0,0,1-7.34-14v88.34a3.64,3.64,0,0,0,1.07,2.59l22.65,22.65a3.67,3.67,0,0,0,2.6,1.08h61v-7.34H53.93Z"/><path class="cls-1" d="M172.84,51.13l-4.33-4.32L163.32,52l3.25,3.25v.2h.11v72.7a58,58,0,0,1,7.24,7V53.73A3.66,3.66,0,0,0,1
 72.84,51.13Z"/><path class="cls-1" d="M14.78,148.88H3.67a3.67,3.67,0,0,1,0-7.34H14.78a3.67,3.67,0,0,1,0,7.34Z"/><path class="cls-1" d="M14.78,118.74H3.67a3.67,3.67,0,0,1,0-7.34H14.78a3.67,3.67,0,1,1,0,7.34Z"/><path class="cls-1" d="M14.78,88.6H3.67a3.67,3.67,0,0,1,0-7.34H14.78a3.67,3.67,0,1,1,0,7.34Z"/><path class="cls-1" d="M14.78,58.46H3.67a3.67,3.67,0,0,1,0-7.34H14.78a3.67,3.67,0,0,1,0,7.34Z"/><path class="cls-1" d="M196.33,148.88H185.22a3.67,3.67,0,1,1,0-7.34h11.11a3.67,3.67,0,0,1,0,7.34Z"/><path class="cls-1" d="M196.33,118.74H185.22a3.67,3.67,0,1,1,0-7.34h11.11a3.67,3.67,0,0,1,0,7.34Z"/><path class="cls-1" d="M196.33,88.6H185.22a3.67,3.67,0,1,1,0-7.34h11.11a3.67,3.67,0,0,1,0,7.34Z"/><path class="cls-1" d="M196.33,58.46H185.22a3.67,3.67,0,1,1,0-7.34h11.11a3.67,3.67,0,0,1,0,7.34Z"/><path class="cls-1" d="M145.21,200a3.67,3.67,0,0,1-3.67-3.67V185.22a3.67,3.67,0,1,1,7.34,0v11.11A3.67,3.67,0,0,1,145.21,200Z"/><path class="cls-1" d="M115.07,200a3.67,3.67,0,0,1-3.67-3.67V185.22a3.67,
 3.67,0,0,1,7.34,0v11.11A3.67,3.67,0,0,1,115.07,200Z"/><path class="cls-1" d="M84.93,200a3.67,3.67,0,0,1-3.67-3.67V185.22a3.67,3.67,0,1,1,7.34,0v11.11A3.67,3.67,0,0,1,84.93,200Z"/><path class="cls-1" d="M54.79,200a3.67,3.67,0,0,1-3.67-3.67V185.22a3.67,3.67,0,0,1,7.34,0v11.11A3.67,3.67,0,0,1,54.79,200Z"/><path class="cls-1" d="M145.21,18.45a3.67,3.67,0,0,1-3.67-3.67V3.67a3.67,3.67,0,1,1,7.34,0V14.78A3.67,3.67,0,0,1,145.21,18.45Z"/><path class="cls-1" d="M115.07,18.45a3.67,3.67,0,0,1-3.67-3.67V3.67a3.67,3.67,0,0,1,7.34,0V14.78A3.67,3.67,0,0,1,115.07,18.45Z"/><path class="cls-1" d="M84.93,18.45a3.67,3.67,0,0,1-3.67-3.67V3.67a3.67,3.67,0,1,1,7.34,0V14.78A3.67,3.67,0,0,1,84.93,18.45Z"/><path class="cls-1" d="M54.79,18.45a3.67,3.67,0,0,1-3.67-3.67V3.67a3.67,3.67,0,0,1,7.34,0V14.78A3.67,3.67,0,0,1,54.79,18.45Z"/><path class="cls-2" d="M87.16,47.72H77.82a3.67,3.67,0,1,1,0-7.34h9.34a3.67,3.67,0,1,1,0,7.34Z"/></svg>
\ No newline at end of file
-- 
2.20.1

