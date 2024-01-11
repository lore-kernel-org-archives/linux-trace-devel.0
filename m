Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F50D58AAC
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 22:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBCEC433C7;
	Thu, 11 Jan 2024 22:20:57 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.97)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1rO3R3-00000000eGa-35BD;
	Thu, 11 Jan 2024 17:22:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 0/3] libtracecmd: Fix iterators
Date: Thu, 11 Jan 2024 17:15:35 -0500
Message-ID: <20240111222201.154686-1-rostedt@goodmis.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The iterators had three issues.

1) It used handle->max_cpu instead of handle->cpus

  max_cpu is the max CPU number that was traced. But if a CPU had no data,
  it was not included in the handle->cpu_data[] array, which is the
  size of handle->cpus. The loop over the cpu_data[] array in the iterators
  stopped at max_cpu and not cpus meaning it could overflow if one of the
  CPUs had no tracing data.

2) There's no reason to free the records at the end of the iterator.
   Not sure why that was done, but it was likely due to another bug that
   was fixed. That freeing just fixed a symptom and not the issue.
   Remove the freeing.

3) The next record for each of the CPUs was cached in a records[] array,
   and when the next record to use was found, it would use that record
   from the records[] array. The issue is if the callback called
   tracecmd_read_data() on any of those records, it would invalidate the
   one returned by "peek". Since the iterator does not know what the
   callback might have done, it would have to refresh all the cached
   records after each call to the callback() function.

   Instead, just save the timestamps of the records for each CPU, and pick
   the CPU with the next timestamp. Do the tracecmd_peek_data() on that
   CPU and make sure it still matches the given timestamp. If it does not,
   then try again.

Steven Rostedt (Google) (3):
  libtracecmd: Use cpu_data[cpu]->cpus and not ->max_cpu
  libtracecmd: Do not free records at end of iterator
  libtracecmd: Just save timestamps and not the records in iterators

 lib/trace-cmd/trace-input.c | 133 ++++++++++++------------------------
 1 file changed, 45 insertions(+), 88 deletions(-)

-- 
2.43.0

