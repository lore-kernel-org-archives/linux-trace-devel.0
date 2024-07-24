Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A001B16D9A4
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jul 2024 18:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721846281; cv=none; b=O3DdEsLNfs2WxBwI9vNifMDnSAhZ59dZDTaCwAtQ94hq8tr4wf9Zj4NfaGArONKjQjHHr2f0KQe1iCws59zktIK08H7NgZal1mGTpOJhijW/TB43mmvyMfqYv1ejmD/iPApz7oKOWPIKC6fzSKPLmvHl3uL5u/qFaFyQzb9RFHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721846281; c=relaxed/simple;
	bh=JrCW/bamDGrebXy0q5Qh/R3adrBDIWOpRzt6bFoRP/0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=mgfrJsLYxC3a1PYG8rgTMO1f/1mmgK/qsgYo6XhxMnKbSV96vp9EW7K+AkUtiuTBoa/RxfUSUHMiSOlBmU1zMKsjbBO1hCjxGz7FayE6E6OJkK1oe2vbRYCvLqXLgpipxSCsI7wQO3Dv7dJFE3e+NF0vZXP5+CqkzRaYEkihjjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C0CC32781;
	Wed, 24 Jul 2024 18:38:00 +0000 (UTC)
Date: Wed, 24 Jul 2024 14:38:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Daniel Wagner <wagi@monom.org>, Tejun Heo <tj@kernel.org>, "Schmidt,
 Adriaan" <adriaan.schmidt@siemens.com>
Subject: [PATCH] trace-cmd meson: Fix include file for swig python build
Message-ID: <20240724143819.073877b3@gandalf.local.home>
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

The header trace-cmd-private-python.h was recently moved to
lib/trace-cmd/include/private. Change the meson.build file to reflect this
change.

Link: https://lore.kernel.org/all/Y+w51nOhNd+PGo%2Fk@slm.duckdns.org/

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 python/meson.build | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/python/meson.build b/python/meson.build
index 5a91ff63a326..d00948947030 100644
--- a/python/meson.build
+++ b/python/meson.build
@@ -22,13 +22,14 @@ if have_python_support
             swig,
             '-python',
             '-I' + meson.current_source_dir() + '/../include/trace-cmd',
+            '-I' + meson.current_source_dir() + '/../lib/trace-cmd/include/private',
             '-I' + libtraceevent_dep.get_pkgconfig_variable('prefix') + '/include/traceevent',
             '-o', '@OUTPUT1@',
             '@INPUT0@'],
         install: true,
         install_dir: [ python3.get_install_dir(pure: false, subdir: 'trace-cmd'), false])
 
-    incdir_py = include_directories(['.', '../include/trace-cmd'])
+    incdir_py = include_directories(['.', '../include/trace-cmd', '../lib/trace-cmd/include/private'])
 
     pyctracecmd_clib = python3.extension_module(
         '_ctracecmd',
-- 
2.43.0

