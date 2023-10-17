Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC402F51B
	for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 23:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD65C433CA;
	Tue, 17 Oct 2023 23:33:27 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qstaa-009G0L-2s;
	Tue, 17 Oct 2023 19:35:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Avidan Borisov <avidanborisov@gmail.com>,
	Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] trace-cmd: Cleanups for --daemonize option
Date: Tue, 17 Oct 2023 19:20:27 -0400
Message-ID: <20231017233503.2205514-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Just a few clean ups for the --daemonize option that I plan on committing
upstream soon. This is based on:

  https://lore.kernel.org/all/20230626091635.3002827-1-avidanborisov@gmail.com/

The first patch lets the daemon be killed with SIGTERM as well as with SIGINT,
as that's the default of "kill" without any option.

The second patch just renames a variable from "rc" to "ret" to be consistent
with the rest of the code.

Steven Rostedt (Google) (2):
  trace-cmd record: Use SIGTERM as well for --daemonize
  trace-cmd record: Cleanup - be consistent with return status variable

 tracecmd/trace-record.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

-- 
2.42.0

