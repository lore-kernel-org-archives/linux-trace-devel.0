Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8D317A2E1
	for <linux-trace-devel@vger.kernel.org>; Fri,  4 Apr 2025 16:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743783238; cv=none; b=gy9TG3PQ6cTTtevZMHJaQnu6QNe84e5YxX7w8ahRucPuOimJFoHerYmTjkIv9VpXq0fbWX8XBS1qfJiTvLOUBL4soGCkS9yuR6ByN1nJeA0JZJlqoCXwxaEL65IvniYoiYlBfwrbGbfH9m8lWgAk2uWU4JSV12qW4m3d0wVmEL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743783238; c=relaxed/simple;
	bh=vJgXpdP7DHdGF6V2aTMAmfxcvYx4jYRI4yslDWpMKeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OykyEYxHbJ9jIfQZbpX5cMtbifRZxxnww9mI7Aw6EH9MTZOx5ktF9hlRMfRPp3n72kBGDX9mlmmCYjJXAt6xMwpJ98YThoSH49vZWsowOHCwmQMOAQziJptB5sRM03ubzRh49+0CyRwxFLgX1K186IPjH/l6qRCxSMmMSQMyoOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E416FC4CEDD;
	Fri,  4 Apr 2025 16:13:57 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1u0jhC-000000070wY-0zQ5;
	Fri, 04 Apr 2025 12:15:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Oleh Matiusha <omatiush@cisco.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] libtracefs: Add make sqlhist_remake to run bison and flex
Date: Fri,  4 Apr 2025 12:12:10 -0400
Message-ID: <20250404161504.1671790-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250404161504.1671790-1-rostedt@goodmis.org>
References: <20250404161504.1671790-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Because git tends to not maintain timestamps of files, the sqlhist.y and
sqlhist.l can end up having an later timestamp than the files they
produce. This triggers bison and flex to be run and recreate the files
sqlhist.tab.h, sqlhist.tab.c and sqlhist-lex.c.

At best, this causes git to see the differences, at worse, the system may
not even have bison or flex and the build fails.

Add a new make target: make sqlhist_remake

This new target will run the bison and flex portions of the build.
It only needs to be run if the files sqlhist.y or sqlhist.l are modified.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Makefile      |  3 +++
 src/Makefile  | 14 ++++++++------
 src/sqlhist.l |  2 ++
 src/sqlhist.y |  1 +
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index bd5c76bcd4f0..6e8022609ee7 100644
--- a/Makefile
+++ b/Makefile
@@ -400,6 +400,9 @@ sqlhist: samples/sqlhist
 samples: libtracefs.a force
 	$(Q)$(call descend,$(src)/samples,all)
 
+sqlhist_remake:
+	$(Q)$(call descend,$(src)/src,sqlhist_remake)
+
 clean: clean_meson
 	$(Q)$(call descend_clean,utest)
 	$(Q)$(call descend_clean,src)
diff --git a/src/Makefile b/src/Makefile
index be81059ce10a..d981d802f8b1 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -46,18 +46,20 @@ $(LIBTRACEFS_SHARED_SO): $(LIBTRACEFS_SHARED_VERSION)
 libtracefs.so: $(LIBTRACEFS_SHARED_SO)
 
 # bison will create both sqlhist.tab.c and sqlhist.tab.h
-sqlhist.tab.h:
-sqlhist.tab.c: sqlhist.y sqlhist.tab.h
-	bison --debug -v --report-file=bison.report -d -o $@ $<
+sqlhist.tab_gen.h:
+sqlhist.tab_gen.c: sqlhist.y sqlhist.tab.h
+	bison --debug -v --report-file=bison.report -d -o $(subst _gen,,$@) $<
 
-sqlhist-lex.c: sqlhist.l sqlhist.tab.c
-	flex -o $@ $<
+sqlhist-lex_gen.c: sqlhist.l sqlhist.tab.c
+	flex -o $(subst _gen,,$@) $<
 
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
 tracefs-sqlhist.o: sqlhist.tab.h
 
+sqlhist_remake: sqlhist.tab_gen.c sqlhist-lex_gen.c
+
 $(OBJS): | $(bdir)
 
 clean:
@@ -67,4 +69,4 @@ clean:
 
 $(bdir)/tracefs-sqlhist.o tracefs-sqlhist.o: sqlhist.tab.h
 
-.PHONY: $(LIBTRACEFS_SHARED_SO) $(LIBTRACEFS_STATIC)
+.PHONY: $(LIBTRACEFS_SHARED_SO) $(LIBTRACEFS_STATIC) sqlhist.tab_gen.c sqlhist-lex_gen.c
diff --git a/src/sqlhist.l b/src/sqlhist.l
index 86e156e52ff7..8b22049a067b 100644
--- a/src/sqlhist.l
+++ b/src/sqlhist.l
@@ -1,6 +1,8 @@
 %{
 /* code here */
 
+/* If you change this file, run: make sqlhist_remake */
+
 #include <stdarg.h>
 #include "sqlhist-parse.h"
 
diff --git a/src/sqlhist.y b/src/sqlhist.y
index 7caa364da28d..c35a1a37f8ce 100644
--- a/src/sqlhist.y
+++ b/src/sqlhist.y
@@ -1,4 +1,5 @@
 %{
+/* If you change this file, run: make sqlhist_remake */
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-- 
2.47.2

