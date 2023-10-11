Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD8F6FD9
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 03:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC1FC433C8;
	Wed, 11 Oct 2023 03:25:18 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqPrt-007ZSf-1Y;
	Tue, 10 Oct 2023 23:26:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 00/11] libtraceeval task-eval: Updates to evaluate tasks
Date: Tue, 10 Oct 2023 23:25:16 -0400
Message-ID: <20231011032640.1804571-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

This series cleans up task-eval and makes it more useful.

Steven Rostedt (Google) (11):
  libtraceeval task-eval: Fix naming conventions of variables
  libtraceeval task-eval: Use "assign_*keys/vals()" helper functions
  libtraceeval task-eval: Add tracking of priority
  libtraceeval task-eval: Add way to read trace.dat buffer instances
  libtraceeval task-eval: Account for ZOMBIE and EXITED states
  libtraceeval task-eval: Show max, min and count of deltas too
  libtraceeval task-eval: Add more comments
  libtraceeval task-eval: Only release results if found
  libtraceeval task-eval: Do not add pdata to non RUNNING tasks
  libtraceveal task-eval: Clean up all traceeval_iterators
  libtraceeval task-evals: Free the libtraceevals

 samples/task-eval.c | 496 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 393 insertions(+), 103 deletions(-)

-- 
2.42.0

