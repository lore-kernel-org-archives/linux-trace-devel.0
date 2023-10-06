Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B3130FA0
	for <linux-trace-devel@vger.kernel.org>; Fri,  6 Oct 2023 20:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041ADC433C8;
	Fri,  6 Oct 2023 20:11:03 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qorBH-005oRc-2H;
	Fri, 06 Oct 2023 16:12:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 0/3] libtraceeval: Add man pages for traceeval_delta
Date: Fri,  6 Oct 2023 16:12:11 -0400
Message-Id: <20231006201214.1385447-1-rostedt@goodmis.org>
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

Changes since v1: https://lore.kernel.org/all/20231006185405.1379249-1-rostedt@goodmis.org/

 - Updated them to show that traceeval_delta_teval_put() only needs the teval
   and not the tdelta.

Steven Rostedt (Google) (3):
  libtraceeval: Add man pages for traceeval_delta init/start/stop
    functions
  libtraceeval: Add man pages for insert/remove/query of traceeval_delta
    items
  libtraceeval: Add man pages for libtraceeval_delta retrieving of
    deltas

 Documentation/libtraceeval-delta-init.txt   | 346 ++++++++++++++++++++
 Documentation/libtraceeval-delta-insert.txt | 122 +++++++
 Documentation/libtraceeval-delta-rest.txt   | 308 +++++++++++++++++
 Documentation/libtraceeval.txt              |  65 ++++
 check-manpages.sh                           |   2 +-
 5 files changed, 842 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/libtraceeval-delta-init.txt
 create mode 100644 Documentation/libtraceeval-delta-insert.txt
 create mode 100644 Documentation/libtraceeval-delta-rest.txt

-- 
2.40.1

