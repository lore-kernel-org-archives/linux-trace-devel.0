Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419003D79
	for <linux-trace-devel@vger.kernel.org>; Sat, 30 Sep 2023 20:24:17 +0000 (UTC)
Received: from smtpcmd0872.aruba.it (smtpcmd0872.aruba.it [62.149.156.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221A3C4
	for <linux-trace-devel@vger.kernel.org>; Sat, 30 Sep 2023 13:24:15 -0700 (PDT)
Received: from localhost.localdomain ([146.241.127.78])
	by Aruba Outgoing Smtp  with ESMTPSA
	id mgVZqGgtGW2JpmgVaqBG4U; Sat, 30 Sep 2023 22:24:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1696105454; bh=qxbhhKubiov8ASQoUpRh37Yv1IX473zTlS6F5TZ0VWo=;
	h=From:To:Subject:Date:MIME-Version;
	b=VuhF0K4yUyLoiPpnIdfp3TCdLBGFzweFQ+R+vTDjRF/0OLuosy3+2MCMdcEBtfarG
	 2pOMH8aKqasM7ASrQZ6IRfwWUcCZbcPFAFmPePSA6ue1X8kzRYyWhNQ7IuiFN3xrNj
	 Q3KZZZRZ9kk6t6mCtoRR5HMZpclNrLHIzhnAbQn+vjV+6p1gXdTndMBehEWLJJ+MSL
	 /fOktCL2l6vmxFni/8TWx9jiYZxhFZRF+oqOA/qmba5Ci1wFhsj9mQMeq4pe6clYYm
	 FE3bp6n2t9RYz3JNl1GXqvdDgkHAD8zDnO95ohbXtzdDOcbKrwPOaXtDPhuiHBGWRB
	 x7gazowDXgcZA==
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
To: linux-trace-devel@vger.kernel.org
Cc: Giulio Benetti <giulio.benetti@benettiengineering.com>
Subject: [PATCH] libtracefs: add option to disable documentation
Date: Sat, 30 Sep 2023 22:24:13 +0200
Message-Id: <20230930202413.2528178-1-giulio.benetti@benettiengineering.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfIiBkGLVf0pXtgUzJY9iGxVuiFhtRchacseOBQ1uoRKWaqLjx/yd7vuB39+fVhzEpZhturw4aL2KlIgTh54fYjqsoteKBXkqdAbmt6+GQ4F7XCHWs51R
 C21lUawQ5DuTVID4X/tGud05zOl1GVNQJTTDeC/+q4q0u1CvFYrV8/l33qR+71J7pzTks/vbGvUGPVQaDbxAbxFqP9pumjFeFCuKszognP4hxv1Vl6/+CitZ
 /IZpsl5b5tDdzpAhHFQCeptkbkE2vZyLCcY4xLctmU+cukOmp4YEGn8QKpPWGimL
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
index 9d42d78..f1e492e 100644
--- a/meson.build
+++ b/meson.build
@@ -39,6 +39,8 @@ if cunit_dep.found()
     subdir('utest')
 endif
 subdir('samples')
+
+if get_option('doc')
 subdir('Documentation')
 
 custom_target(
@@ -46,3 +48,4 @@ custom_target(
     output: 'docs',
     depends: [html, man],
     command: ['echo'])
+endif
diff --git a/meson_options.txt b/meson_options.txt
index 1d92c28..5533a88 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -14,3 +14,5 @@ option('man-bold-literal', type : 'boolean', value : false,
        description : 'enable bold literals')
 option('docbook-suppress-sp', type : 'boolean', value : false,
        description : 'docbook suppress sp')
+option('doc', type : 'boolean', value: true,
+       description : 'produce documentation')
-- 
2.34.1

