Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63AFD17F3
	for <linux-trace-devel@vger.kernel.org>; Sat,  6 Jan 2024 04:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2BDC433C9;
	Sat,  6 Jan 2024 04:23:21 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rLyEY-00000001An2-0DlG;
	Fri, 05 Jan 2024 23:24:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] trace-cmd: Add sqlhist option and show hist and triggers
Date: Fri,  5 Jan 2024 23:22:26 -0500
Message-ID: <20240106042428.279706-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add a new command "sqlhist" to do the "sqlhist" code that is in the
tracefs_sql() man page. sqlhist is still relatively unknown, by adding it to
trace-cmd, it may become more public.

Also add show --hist to show the output of a trace event histogram and
--trigger to show the contents of the trigger file.

Steven Rostedt (Google) (3):
  trace-cmd show: Add --hist and --trigger options
  trace-cmd sqlhist: Add 'sqlhist' command
  trace-cmd utest: Add tests for trace-cmd sqlhist

 Documentation/trace-cmd/trace-cmd-show.1.txt  |   6 +
 .../trace-cmd/trace-cmd-sqlhist.1.txt         | 339 ++++++++++++++++++
 tracecmd/Makefile                             |   1 +
 tracecmd/include/trace-local.h                |   2 +
 tracecmd/trace-cmd.c                          |   1 +
 tracecmd/trace-show.c                         |  51 +++
 tracecmd/trace-sqlhist.c                      | 246 +++++++++++++
 tracecmd/trace-usage.c                        |  20 +-
 utest/tracecmd-utest.c                        |  28 ++
 9 files changed, 693 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/trace-cmd/trace-cmd-sqlhist.1.txt
 create mode 100644 tracecmd/trace-sqlhist.c

-- 
2.42.0

