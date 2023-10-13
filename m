Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295C6371
	for <linux-trace-devel@vger.kernel.org>; Fri, 13 Oct 2023 00:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BCBC433CA;
	Fri, 13 Oct 2023 00:48:59 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qr6Nm-008Upf-1F;
	Thu, 12 Oct 2023 20:50:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtraceeval: Document traceeval_delta_* functions
Date: Thu, 12 Oct 2023 20:49:26 -0400
Message-ID: <20231013005025.2025080-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add man pages (and examples) for all the traceeval_delta_* and related functions.

Steven Rostedt (Google) (2):
  libtraceeval: Add man pages for traceeval_delta create/start/stop
    functions
  libtraceeval: Add man pages for libtraceeval_delta retrieving of
    deltas

 Documentation/libtraceeval-delta-init.txt | 470 ++++++++++++++++++++++
 Documentation/libtraceeval-delta-rest.txt | 292 ++++++++++++++
 Documentation/libtraceeval.txt            |  54 +++
 3 files changed, 816 insertions(+)
 create mode 100644 Documentation/libtraceeval-delta-init.txt
 create mode 100644 Documentation/libtraceeval-delta-rest.txt

-- 
2.42.0

