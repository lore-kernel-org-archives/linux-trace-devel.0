Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1AF13DDB6
	for <linux-trace-devel@vger.kernel.org>; Fri, 17 May 2024 19:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715974219; cv=none; b=BRMMbiWFpKTxtYhy29UmxEMWUq7bBHiHdae/XqT/6oT2OpRHI5fBkJJvq+sLn245ur7Hx7slaKb3diE+LEO/fwM0kibj0pMkxSEJvbFaMMMu0njhlbo8tNURk8KcwSvXac5gFRI7Hu/FWI5O4z2r8B2v7DPA+cPnuzbYoEL8yBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715974219; c=relaxed/simple;
	bh=wvaOqck5wIeUb+BcjS6dP3G/b1i/xJ3+T4rkQO9GWvY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=eO1xPVsolFqeGaBl+w1R5aXzuz+HGb6OwYd+Ls6UqhT6CsvZchTQ/9oN6CuTh3n+i0b2fpvw/BbHL7W2XxYf94p/CUGNYS6PgYxbkcE+MPuiKR+21R3Ps7s29z9r71VN7qlD+K3izjqJ43bTNufnATE2kclrfuC2oEgkwPV+gxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6608DC2BD10
	for <linux-trace-devel@vger.kernel.org>; Fri, 17 May 2024 19:30:18 +0000 (UTC)
Date: Fri, 17 May 2024 15:30:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Add trace-mmap.c to meson build
Message-ID: <20240517153049.525c8588@gandalf.local.home>
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

The trace-mmap.c file was missing from the meson build which caused the
meson build to fail to compile.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/meson.build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/meson.build b/src/meson.build
index 5b7655453f50..adcb8c71f018 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -16,6 +16,7 @@ sources= [
    'tracefs-tools.c',
    'tracefs-uprobes.c',
    'tracefs-utils.c',
+   'tracefs-mmap.c',
 ]
 
 flex = find_program('flex', required: true)
-- 
2.43.0

