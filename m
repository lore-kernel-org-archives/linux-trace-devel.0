Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED945CBA
	for <linux-trace-devel@vger.kernel.org>; Mon,  9 Oct 2023 02:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B95C433CA;
	Mon,  9 Oct 2023 02:52:38 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qpgP5-006cYu-2X;
	Sun, 08 Oct 2023 22:53:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v3 0/2] libtraceeval: Add delta interface
Date: Sun,  8 Oct 2023 22:53:52 -0400
Message-Id: <20231009025354.1577934-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The first iteration of libtraceeval sought out to facilitate timings
between events. For instance, the time between waking up and scheduling in
of a task (the wake up latency). But that code API quickly became
unusable, as there were several use cases that did not need the timings,
and it was awkward using it.

The libtraceeval was redesigned to be simple histograms that could be
queried for the last instance, and easily have them be joined. This worked
well.

Now this adds a new interface to only require a single traceeval again,
but with a attached simple "delta" traceeval internally. This internal
traceeval keeps track of the timestamps and calculates a delta to be used to
insert.

Man pages will come later.

Changes since v2: https://lore.kernel.org/all/20231006160252.009f9560@gandalf.local.home/

- This is a basic redesign. Instead of creating a traceeval_delta instance,
  which when playing with it I found it to be too limiting in its use (although
  it was simple). This design is to just add a way to create a new key mapping
  for the start and stop events. This also allows the start to pass values to
  the stop (much like how the ftrace synthetic events work), and then these
  values can be used to insert into the main traceeval.

Steven Rostedt (Google) (2):
  libtraceeval: Add traceeval_delta_start/continue/stop() API
  libtraceeval: Add traceeval_iterator_delta_start_get()

 include/traceeval.h |  59 ++++
 samples/task-eval.c | 649 ++++++++++++++++++++++----------------------
 samples/wake-lat.c  |  61 ++---
 src/Makefile        |   1 +
 src/delta.c         | 431 +++++++++++++++++++++++++++++
 src/eval-local.h    |  21 ++
 src/histograms.c    | 137 ++++++----
 7 files changed, 943 insertions(+), 416 deletions(-)
 create mode 100644 src/delta.c

-- 
2.40.1

