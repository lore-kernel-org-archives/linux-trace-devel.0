Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE2E36090
	for <linux-trace-devel@vger.kernel.org>; Fri,  5 Jan 2024 19:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A64C433C9;
	Fri,  5 Jan 2024 19:39:07 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rLq3E-000000013us-2O5H;
	Fri, 05 Jan 2024 14:40:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] kbuffer: Some minor fixes
Date: Fri,  5 Jan 2024 14:37:41 -0500
Message-ID: <20240105194015.253165-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The kbuffer update to work with libtracefs mmapping code had a few bugs.

1) The man page was missing its prototype for tep_kbuffer()

2) A buffer passed in to kbuffer_read_buffer() that was just big enough to
   hold the events, was not completely filled.

3) kbuffer_refresh() left the current event zero size, even if new data was
   added after it, if the last read was at the end of the page.

Steven Rostedt (Google) (3):
  libtraceevent Documentation: Fix tep_kbuffer() prototype
  kbuffer: Add event if the buffer just fits in kbuffer_read_buffer()
  kbuffer: Update kbuf->next in kbuffer_refresh()

 Documentation/libtraceevent-handle.txt |  1 +
 Documentation/libtraceevent.txt        |  2 +-
 src/kbuffer-parse.c                    | 16 +++++++++++++++-
 3 files changed, 17 insertions(+), 2 deletions(-)

-- 
2.42.0

