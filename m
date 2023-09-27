Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0A81C6A3
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42791C433CB;
	Wed, 27 Sep 2023 12:32:23 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1qlTj9-0049TN-05;
	Wed, 27 Sep 2023 08:33:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: Ross Zwisler <zwisler@google.com>,
	Stevie Alvarez <stevie.6strings@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v2 00/11] libtraceeval: Even more updates!
Date: Wed, 27 Sep 2023 08:33:03 -0400
Message-Id: <20230927123314.989589-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

More updates to libtraceeval

- As the results and stats are often needed in the iterator loops, add helper
  functions to quickly retrieve them. The iterator has a handle on the current
  entry, no need to do a key lookup to find it.

- The iterator can be used to search for items to remove or update. Add a
  helper function to remove the current iterator item. This will also update
  the iterator so that other functions called are still safe, even if the removed
  entry is the current one.

- Convert traceeval_data into a proper structure with a "type" field and a
  union data portion. This will allow for checking the type of data being
  passed into the functions to make sure they match their corresponding types.

- Add checks to make sure that the data matches the types.

- Make traceeval_insert() and traceeval_query() into macros and add a
  traceeval_query_size() and traceeval_insert_size() that take the size of the
  list of data being passed into it. The macros work when the arrays are defined.

- Add checks to make sure the array sizes passed in match the sizes internally.

- Add back the STATS flag, and only do STATS on values that are numeric and
  have this set. This should speed things up, and also allow for optimizations
  in the future.

Changes since v1: https://lore.kernel.org/linux-trace-devel/20230817222422.118568-1-rostedt@goodmis.org/

- Use of ARRAY_SIZE() macro to make some other macro logic simpler.

- Fix TRACEEVAL_FL_STAT (was a duplicate of 3 not 4) (Ross Zwisler)

- Add traceeval_remove_size() to check traceeval_remove()

- Add traceeval_query_size() to check traceeval_query()

- Add traceeval_stat_size() to check traceeval_stat()

- Add traceeval_iterator_results_release()

- Use TRACEEVAL_SET_NUMBER() on keys in task-eval.c (Ross Zwisler)

- Use is_stat_type() in copy_traceeval_data() (Ross Zwisler)

- Add type test to update_entry() (Ross Zwisler)

- Folded checking patch into size check patches (Ross Zwisler)

- Free entry on traceeval_remove() and trace_iterator_remove (Ross Zwisler)

- Fix added tab of return -1 (Ross Zwisler)

- Fix comment of traceeval_iterator_query() (Ross Zwisler)

- Fix comment of traceeval_iterator_remove() (Ross Zwisler)


Steven Rostedt (Google) (11):
  libtraceeval: Add check for updates to know to recreate iter array
  libtraceeval: Add traceeval_iterator_query()
  libtraceeval: Add traceeval_iterator_results_release()
  libtraceeval: Add traceeval_iterator_stat()
  libtraceeval: Add traceeval_iterator_remove()
  libtraceeval histogram: Add type to traceeval_data and make it a
    structure
  libtraceveal: Add type checks to traceeval_data vals and keys
  libtraceeval: Add size checks to insert and query functions
  libtraceeval: Make traceeval_remove() check size of keys array
  libtraceeval: Make traceeval_stat() check size of keys array
  libtraceeval: Only do stats on values marked with the STAT flag

 include/traceeval-hist.h | 118 +++++++++----
 samples/task-eval.c      | 148 +++++++----------
 src/eval-local.h         |   6 +-
 src/histograms.c         | 349 +++++++++++++++++++++++++++++++--------
 4 files changed, 429 insertions(+), 192 deletions(-)

-- 
2.40.1

