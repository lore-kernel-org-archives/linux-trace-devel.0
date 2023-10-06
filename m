Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807C138F99
	for <linux-trace-devel@vger.kernel.org>; Fri,  6 Oct 2023 18:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2E8C433CA;
	Fri,  6 Oct 2023 18:52:54 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qopxe-005moV-1l;
	Fri, 06 Oct 2023 14:54:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] libtraceeval: Add man pages for traceeval_delta
Date: Fri,  6 Oct 2023 14:54:02 -0400
Message-Id: <20231006185405.1379249-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the necessary man pages for traceeval_delta.

Steven Rostedt (Google) (3):
  libtraceeval: Add man pages for traceeval_delta init/start/stop
    functions
  libtraceeval: Add man pages for insert/remove/query of traceeval_delta
    items
  libtraceeval: Add man pages for libtraceeval_delta retrieving of
    deltas

 Documentation/libtraceeval-delta-init.txt   | 346 ++++++++++++++++++++
 Documentation/libtraceeval-delta-insert.txt | 122 +++++++
 Documentation/libtraceeval-delta-rest.txt   | 309 +++++++++++++++++
 Documentation/libtraceeval.txt              |  65 ++++
 check-manpages.sh                           |   2 +-
 5 files changed, 843 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/libtraceeval-delta-init.txt
 create mode 100644 Documentation/libtraceeval-delta-insert.txt
 create mode 100644 Documentation/libtraceeval-delta-rest.txt

-- 
2.40.1

