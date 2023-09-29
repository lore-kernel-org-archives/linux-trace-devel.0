Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56C78465
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Sep 2023 09:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8604BC433CA;
	Fri, 29 Sep 2023 09:59:32 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qmAIO-004Gtz-1J;
	Fri, 29 Sep 2023 06:00:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/2] libtraceeval: Remove the need of TRACEEVAL_TYPE_NONE
Date: Fri, 29 Sep 2023 06:00:23 -0400
Message-Id: <20230929100025.1018258-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The use of macros to determine the size of the keys and vals arrays made
me think a bit more about how we initialize the traceeval. The more I'm
using the library, the less I like having to add the TRACEEVAL_TYPE_NONE
to the end of the keys and vals array.

Instead, use the same macro trick of TRACEEVAL_ARRAY_SIZE() to determine
the number of elements. Still allow the use of using the
TRACEEVAL_TYPE_NONE to determine the size (if the number passed in is
still bigger), so that most applications that still use that still work.

I made the change separate than updating the sample code to test that
the old way still works. Then I updated the sample to make sure the new
way works. Perhaps when we add unit tests back in, we'll test both
cases.

Steven Rostedt (Google) (2):
  libtraceeval: Remove need to use TRACEEVAL_TYPE_NONE in keys and vals
  libtraceeval samples: Remove adding TRACEEVAL_TYPE_NONE to keys and
    vals

 include/traceeval-hist.h | 11 +++++++++--
 samples/task-eval.c      | 18 ------------------
 src/histograms.c         | 11 +++++++----
 3 files changed, 16 insertions(+), 24 deletions(-)

-- 
2.40.1

