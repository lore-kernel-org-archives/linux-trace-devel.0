Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7774121C
	for <linux-trace-devel@vger.kernel.org>; Fri,  6 Oct 2023 19:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1845C433CD;
	Fri,  6 Oct 2023 19:54:25 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qoqvC-005o90-0f;
	Fri, 06 Oct 2023 15:55:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 0/5] libtraceeval: Add man pages
Date: Fri,  6 Oct 2023 15:55:31 -0400
Message-Id: <20231006195536.1384287-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

This series adds the man pages for all the currently defined APIs in
traceeval.h.

Changes since v1: https://lore.kernel.org/all/20231005232450.1311519-1-rostedt@goodmis.org/

 - Made one of the examples a bit smaller (was too big, although it's still pretty big)

 - Fixed up missing traceeval_iterator_put() in the examples.

Steven Rostedt (Google) (5):
  libtraceeval: Start creating the documentation man pages
  libtraceeval: Add man pages for creating and releasing the traceeval
    descriptor
  libtraceeval: Add man pages for insertion and removal of elements in a
    traceeval
  libtraceeval: Add man pages for the traceeval iterator functions
  libtraceeval: Add man pages for traceeval statistics

 Documentation/.gitignore                |   4 +
 Documentation/Makefile                  | 247 +++++++
 Documentation/asciidoc.conf             | 120 +++
 Documentation/libtraceeval-init.txt     | 395 ++++++++++
 Documentation/libtraceeval-insert.txt   | 390 ++++++++++
 Documentation/libtraceeval-iterator.txt | 921 ++++++++++++++++++++++++
 Documentation/libtraceeval-stat.txt     | 308 ++++++++
 Documentation/libtraceeval.txt          | 118 +++
 Documentation/manpage-1.72.xsl          |  14 +
 Documentation/manpage-base.xsl          |  35 +
 Documentation/manpage-bold-literal.xsl  |  17 +
 Documentation/manpage-normal.xsl        |  13 +
 Documentation/manpage-suppress-sp.xsl   |  21 +
 check-manpages.sh                       |  63 ++
 14 files changed, 2666 insertions(+)
 create mode 100644 Documentation/.gitignore
 create mode 100644 Documentation/Makefile
 create mode 100644 Documentation/asciidoc.conf
 create mode 100644 Documentation/libtraceeval-init.txt
 create mode 100644 Documentation/libtraceeval-insert.txt
 create mode 100644 Documentation/libtraceeval-iterator.txt
 create mode 100644 Documentation/libtraceeval-stat.txt
 create mode 100644 Documentation/libtraceeval.txt
 create mode 100644 Documentation/manpage-1.72.xsl
 create mode 100644 Documentation/manpage-base.xsl
 create mode 100644 Documentation/manpage-bold-literal.xsl
 create mode 100644 Documentation/manpage-normal.xsl
 create mode 100644 Documentation/manpage-suppress-sp.xsl
 create mode 100755 check-manpages.sh

-- 
2.40.1

