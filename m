Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B549A10F
	for <linux-trace-devel@vger.kernel.org>; Tue,  5 Dec 2023 02:58:32 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AE91921EAD;
	Tue,  5 Dec 2023 10:58:30 +0000 (UTC)
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B7E3139E2;
	Tue,  5 Dec 2023 10:58:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id FNB9JFYCb2UgQgAAn2gu4w
	(envelope-from <dwagner@suse.de>); Tue, 05 Dec 2023 10:58:30 +0000
From: Daniel Wagner <dwagner@suse.de>
To: linux-trace-devel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] libtracecmd: add trace-rbtree to meson build
Date: Tue,  5 Dec 2023 11:58:26 +0100
Message-ID: <20231205105826.16428-1-dwagner@suse.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++++++++++++++
X-Spam-Score: 18.29
X-Rspamd-Server: rspamd1
Authentication-Results: smtp-out1.suse.de;
	dkim=none;
	spf=softfail (smtp-out1.suse.de: 2a07:de40:b281:104:10:150:64:98 is neither permitted nor denied by domain of dwagner@suse.de) smtp.mailfrom=dwagner@suse.de;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=suse.de (policy=none)
X-Rspamd-Queue-Id: AE91921EAD
X-Spamd-Result: default: False [18.29 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_SPAM(0.00)[17.67%];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_SPAM_SHORT(3.00)[1.000];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 R_SPF_SOFTFAIL(4.60)[~all:c];
	 RCVD_COUNT_THREE(0.00)[3];
	 TO_DN_SOME(0.00)[];
	 MX_GOOD(-0.01)[];
	 NEURAL_SPAM_LONG(3.50)[1.000];
	 MID_CONTAINS_FROM(1.00)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 DMARC_POLICY_SOFTFAIL(0.10)[suse.de : No valid SPF, No valid DKIM,none]

A red black tree implementation was recently added but it only enabled
for the make build process. Add it also to the meson build.

Fixes: 5274db32a7ef ("libtracecmd: Use an rbtree for mapping of cache pages")
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 lib/trace-cmd/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/trace-cmd/meson.build b/lib/trace-cmd/meson.build
index 2193e5265b22..25bdd36357bc 100644
--- a/lib/trace-cmd/meson.build
+++ b/lib/trace-cmd/meson.build
@@ -4,6 +4,7 @@
 
 sources = [
     'trace-hash.c',
+    'trace-rbtree.c',
     'trace-hooks.c',
     'trace-input.c',
     'trace-output.c',
-- 
2.43.0

