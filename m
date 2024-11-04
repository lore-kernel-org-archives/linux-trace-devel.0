Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6D21CC178
	for <linux-trace-devel@vger.kernel.org>; Mon,  4 Nov 2024 20:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730751817; cv=none; b=D04sQXR8DXX1iWnAxvVc130wf7mnqIYfi8xSH0QQ/GmGLXWutiLFQM7Y8odllSiyTuQjDMC0MvvK6CqNQ9HUjuhVvP1SdA1FJ0CSuNZZVCzjRsmwd43WUUGHWmRiMHGVnIaPW3AHJGaImRf8sDd7oibGe+kmiAVXVb/6ESyL8lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730751817; c=relaxed/simple;
	bh=Ez4QAxLIjXUDZXPMiXNyWQdkZVrgzL6vjlWSKsshRlM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=IQAqhu8NghiobFreKzIRGF4EaFXKj583q2+3YZDkyjz4njHS5iFIdPDWKuVJT3fogSAnSCWM8s/iNRa363DRvFuAZySwJ//oeG7/O64yW7muy0bxnxEUzh5sTC/wpnbtqiarQtw20xlumEFoVjSMqzlkM/pz+EVpOlCqxxP411c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D786BC4CECE
	for <linux-trace-devel@vger.kernel.org>; Mon,  4 Nov 2024 20:23:36 +0000 (UTC)
Date: Mon, 4 Nov 2024 15:23:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd sqlhist: Fix missing initialization of a var
Message-ID: <20241104152335.0fcb2d7d@gandalf.local.home>
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

The variable "var" was used without being initialized and caused bugs when
it wasn't set via: -m or -c options.

Fixes: 1d5ac88ee ("trace-cmd sqlhist: Add 'sqlhist' command")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-sqlhist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-sqlhist.c b/tracecmd/trace-sqlhist.c
index f53feb24..9e304e43 100644
--- a/tracecmd/trace-sqlhist.c
+++ b/tracecmd/trace-sqlhist.c
@@ -137,7 +137,7 @@ void trace_sqlhist (int argc, char **argv)
 	bool execute = false;
 	char **save_fields = NULL;
 	const char *name;
-	const char *var;
+	const char *var = NULL;
 	char **save_argv;
 	int action = 0;
 	char *tok;
-- 
2.43.0

