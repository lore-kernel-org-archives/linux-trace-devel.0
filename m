Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3B63218B
	for <linux-trace-devel@vger.kernel.org>; Tue, 10 Oct 2023 19:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70D4C433D9;
	Tue, 10 Oct 2023 19:55:34 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qqIqe-007VW4-1a;
	Tue, 10 Oct 2023 15:56:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtraceeval: Add warning messages
Date: Tue, 10 Oct 2023 15:55:24 -0400
Message-ID: <20231010195655.1789420-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Change the output to use traceeval_vwarning() and create a log level like
libtraceevent and libtracefs have. This lets the application run with warnings
enabled when developing, and be able to turn them off for production.

Steven Rostedt (Google) (2):
  libtraceeval: Add traceeval_vwaring() API
  libtraceeval: Have various errors print warnings

 include/traceeval.h |  11 +++
 src/delta.c         |  40 +++++++--
 src/eval-local.h    |   9 ++
 src/histograms.c    | 200 ++++++++++++++++++++++++++++++++++++--------
 4 files changed, 215 insertions(+), 45 deletions(-)

-- 
2.42.0

