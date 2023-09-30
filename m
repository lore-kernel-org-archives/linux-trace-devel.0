Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC369CA45
	for <linux-trace-devel@vger.kernel.org>; Sat, 30 Sep 2023 20:14:46 +0000 (UTC)
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 30 Sep 2023 13:14:44 PDT
Received: from smtpcmd13146.aruba.it (smtpcmd13146.aruba.it [62.149.156.146])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3956BBD
	for <linux-trace-devel@vger.kernel.org>; Sat, 30 Sep 2023 13:14:44 -0700 (PDT)
Received: from localhost.localdomain ([146.241.127.78])
	by Aruba Outgoing Smtp  with ESMTPSA
	id mgLMqsC6Ja8HKmgLMqo4fv; Sat, 30 Sep 2023 22:13:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1696104820; bh=pFJfiixZNF9PItL8DvkF3Oo0cDa0Ljt9HJJiX3o0s+k=;
	h=From:To:Subject:Date:MIME-Version;
	b=fT5Vc7f5ANHj2S7JjE7lRHKHrxG0bDGLLyCmiU9JYxVyVDGx0UclpEHny99eaFHvU
	 J/OD1nuDUfyzP0UCjTelQqj90Ilmmm0rFbDXqZea2a3qAEOTwGK1s25s79QvFXEhqi
	 MkPNqVWCm2z0i3vJ8J0QdfNLOq092GPUbTBXxCQ0F+xYKLlMoy73CV/Ah5hj4dTfu0
	 6I5GoEQIWbb/nGyiYDjnQKZnMJwLFd7sCYk0JKICOGT77QG/IrWk79o7Ki1tDJyRc+
	 oNWq4ElsRkjDEGdr6E5ZzW4JcdzaZU4oFP2ln1Rv9Egzy56ELIfxJVdP8UnKtJcG66
	 Rt7VJzTc5Z74g==
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
To: linux-trace-devel@vger.kernel.org
Cc: Giulio Benetti <giulio.benetti@benettiengineering.com>
Subject: [PATCH] libtraceevent: add option to disable documentation
Date: Sat, 30 Sep 2023 22:13:39 +0200
Message-Id: <20230930201339.2525344-1-giulio.benetti@benettiengineering.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfHq7HguHMPbSC9SxQhibn4M9w2nznieMijy2CotU9ykMyBUiTStWP9+9Qqq2xi7z/uB1+dyRTkQVLxJeZLI713ADDHkAm3sNdBZkehvuT1j2PEaGyS89
 xvFabrFZjjvLqtW14XVgrG2QQA2bq5owFo0pSd8h8PXxyiPXKrsPTGsgukqq+XKeylvHt+7ApFpUqlj4jPQjcDegQIdgJNRXxn7qMdfPBwCRLVQcj/lJzJ0X
 XZKcsHgbHDZIETbJvLcMa1vERd8nwkefmAMrbrNPExnncUWznOK/BQe5IeNW5jIx
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
---
 meson.build       | 3 +++
 meson_options.txt | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/meson.build b/meson.build
index b61c873..9a18e02 100644
--- a/meson.build
+++ b/meson.build
@@ -45,6 +45,8 @@ if cunit_dep.found()
     subdir('utest')
 endif
 subdir('samples')
+
+if get_option('doc')
 subdir('Documentation')
 
 custom_target(
@@ -52,3 +54,4 @@ custom_target(
     output: 'docs',
     depends: [html, man],
     command: ['echo'])
+endif
diff --git a/meson_options.txt b/meson_options.txt
index b2294f6..9a40dad 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -16,3 +16,5 @@ option('man-bold-literal', type : 'boolean', value : false,
        description : 'enable bold literals')
 option('docbook-suppress-sp', type : 'boolean', value : false,
        description : 'docbook suppress sp')
+option('doc', type : 'boolean', value: true,
+       description : 'produce documentation')
-- 
2.34.1

