Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7007E19AD91
	for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2024 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721921160; cv=none; b=PbW5xqmKSmJUnb85mg29uYqTxoX1xwiKyKdK/5ZaX//iQfB0SDgkamibIfc0yIBg1BWEszVfJ6ZLrgd9XdPub2EmLZZDHmLIQuF7M+3U3XtR/Adq+gs4x73iQ/qmoBjTnH5OX42Oeb4NHWlUbXNCDyuItaylszpmORRfWKAYjv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721921160; c=relaxed/simple;
	bh=saffLNBNZ3Nxfj5rtKvhotUSi9rH33r0sG16fEO1nLg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=NjnLa4vXXYqr/mocR6VnqHUSomv0djK2/MN7KJQFa7HmgYpf3b+Q2H0FXE9IqWcEXE9zFhQEcEOmo17Vyv7XlBCMHhfI5Wlmb5Mg5TCMIzJL4PczjaGTy1d0LNV8BBD1IRzdkqITBdXeczAttZq68nyhqAqhU51toHMSS/gzbUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01885C116B1;
	Thu, 25 Jul 2024 15:25:59 +0000 (UTC)
Date: Thu, 25 Jul 2024 11:26:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Daniel Wagner <wagi@monom.org>
Subject: [PATCH] trace-cmd documentation: Remove check-manpages.sh for
 trace-cmd in meson build
Message-ID: <20240725112620.17c6d1b2@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The creation of man pages for trace-cmd ran the check-manpages.sh script,
which is only used for the libtracecmd library, not the tools. This caused
the build to spit out warning of grep not finding libtracecmd.txt.

Fixes: 736df0648d16b ("trace-cmd: Add initial support for meson")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/trace-cmd/meson.build | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/Documentation/trace-cmd/meson.build b/Documentation/trace-cmd/meson.build
index d0cc3076d985..875d72832a0b 100644
--- a/Documentation/trace-cmd/meson.build
+++ b/Documentation/trace-cmd/meson.build
@@ -104,13 +104,6 @@ if get_option('docbook-suppress-sp')
     xmlto_extra += ['-m ',  confdir + 'manpage-suppress-sp.xsl']
 endif
 
-check_doc = custom_target(
-    'check-doc',
-    output: 'dummy',
-    command : [
-        top_source_dir + 'check-manpages.sh',
-        meson.current_source_dir()])
-
 gen = generator(
     asciidoc,
     output: '@BASENAME@.xml',
@@ -131,7 +124,6 @@ foreach txt, section : sources
         txt.underscorify() + '_man',
         input: xml,
         output: '@BASENAME@.' + section,
-        depends: check_doc,
         command: [
             xmlto,
             '-m', manpage_xsl,
@@ -145,7 +137,6 @@ foreach txt, section : sources
         txt.underscorify() + '_html',
         input: txt,
         output: '@BASENAME@.html',
-        depends: check_doc,
         command: [
             asciidoc,
             '-b', asciidoc_html,
-- 
2.43.0

