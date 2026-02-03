Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914B82FF14C
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Feb 2026 23:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770160478; cv=none; b=eEvd8/kGefy684oXqKvojob22N2PJGWxY+rfLr5PcxfYbXytos9aW3x4bfTQpYJqKdxS0hvm1fgGEQ24w+L20Htt4sYcDQhCE9kY7H9xR7WqEI9ZDFQdjN42ebMcq0oP18s5Lw810T+/a17UOErwD6qLaGl5yH+mgK8UwDoVWsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770160478; c=relaxed/simple;
	bh=Xn6/7vdwlIH3nEvRXGgtHjPlSa5oCmNcCnWl76SUFwg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kpDfIoAEuRAeoCnAjGKIrCp9f4FPDjnrk3PQxG8GUUA15nATmdXWeP6J9lSwObnmJLyyo3qT6WQbwUBr+dUKf+skYXuCMqNEPjHcPNNWqnZvhWYdRRue9zmtYgnO6U51veer1O4Wjmu2N3quDUGOEX3E+K+8suLog/oACVVuVoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660BFC2BC86;
	Tue,  3 Feb 2026 23:14:38 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.99.1)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1vnPbw-00000008swH-0ABB;
	Tue, 03 Feb 2026 18:15:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtraceevent: Add ways to read last boot info
Date: Tue,  3 Feb 2026 18:12:24 -0500
Message-ID: <20260203231507.2117658-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When a persistent ring buffer is used to record a trace and the kernel
crashes (or simply reboots), the function addresses in the buffer from the
previous boot will not match the funciton addresses in the kallsyms of the
current boot.

To solve this, the kernel creates a "last_boot_info" file in the instance
directory. This holds the offsets of where "_text" is located for the core
kernel code as well as where each module is loaded.

Add API to read the last_boot_info file as well as /proc/modules and use
this to calculate function addresses based on the kallsyms of the current
boot and the last_boot_info file that has the information of the previous
boot.

Steven Rostedt (Google) (2):
  libtraceevent: Add tep_parse_last_boot_info()
  libtraceevent: Add tep_load_modules() API

 Documentation/libtraceevent-parse-files.txt |  80 +++++-
 Documentation/libtraceevent.txt             |   2 +
 include/traceevent/event-parse.h            |   2 +
 src/event-parse-local.h                     |   9 +
 src/event-parse.c                           | 290 +++++++++++++++++++-
 src/trace-btf.c                             |   6 +
 6 files changed, 377 insertions(+), 12 deletions(-)

-- 
2.51.0

