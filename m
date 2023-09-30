Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1774F18C35
	for <linux-trace-devel@vger.kernel.org>; Sat, 30 Sep 2023 20:40:20 +0000 (UTC)
Received: from smtpcmd13147.aruba.it (smtpcmd13147.aruba.it [62.149.156.147])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5C4DD
	for <linux-trace-devel@vger.kernel.org>; Sat, 30 Sep 2023 13:40:18 -0700 (PDT)
Received: from localhost.localdomain ([146.241.127.78])
	by Aruba Outgoing Smtp  with ESMTPSA
	id mgl8qsNdGa8HKmgl8qo8vT; Sat, 30 Sep 2023 22:40:18 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1696106418; bh=HZYFCTb7d05yiLEZ+4ElzX0SgqPYIU/yrYS7tt3Puaw=;
	h=From:To:Subject:Date:MIME-Version;
	b=ernxisX8QCg0cWmzNlsJf42JV21nmglk2ItW362s2RaZMks/jpFc5yGENO741/ank
	 J9Q0oY853nbKcl1mpS8sCiZwUL/4OV/eJfFHbLzLex+ovLBJy4NzpAiU/x4qYkzlLz
	 HCwcfH/1nMKWPMJSTNCNKeUjagiIevKmApt7dvJpLJ/XQe1q0orTBYK7DB2/BUujhI
	 oQ4wqZbXhXOq+cJxSGoRPwYUBbNgdRze+SiZwSbLuq0N+QikcqdXL1QTlZxzLCF16q
	 VC1uod77FmtU3WnIIXLvTwriDF0O904H99ted9IEgR6v7x6Eg1LivGpN/DpYa8IiI6
	 0FEBcvyDdg3Ww==
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
To: linux-trace-devel@vger.kernel.org
Cc: Giulio Benetti <giulio.benetti@benettiengineering.com>
Subject: [PATCH v2] libtraceevent: add option to disable documentation
Date: Sat, 30 Sep 2023 22:40:17 +0200
Message-Id: <20230930204017.2528627-1-giulio.benetti@benettiengineering.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfEEmAlp6UO7T3xO7LGZlRU06DgOLlbVI+23Rm8iZknYaxNalqifLvAbxZhv4ayJ/PmCVtIQN6nc+xAaLwCl2DHi2buotW9PPdeLme+F51MLHPPzytjXX
 AuqOtyvqs3qsBm+TnM9+MEuTFb+GIWOuzvCsKzLNnKpqgap7DQwAyDxd1e9+7XSnSWc97Roq9EFZRXpYU6ntKs94rTSajItktdZNKyIOWIgjbYscY9IC2FYL
 //KEhXF1c5+fQnAkZkscgdmrCMLuq0VFoudERb5vE4nOIPxVQpTKYMqUb/5RXV+z
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On some Linux environment builder(i.e. Buildroot) host asciidoc is not
provided since by default all man/docs are not installed to target but
meson.build at the moment build ascii and html documentation and
requires asciidoc making the building to fail. So let's add doc option
set to true by default to let the user to override it and not produce
the documentation.

Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
---
V1->V2:
* improve commit log as suggested by Steve Rostedt
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

