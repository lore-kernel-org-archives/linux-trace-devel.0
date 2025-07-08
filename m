Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8365383
	for <linux-trace-devel@vger.kernel.org>; Tue,  8 Jul 2025 18:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752000415; cv=none; b=HjtmkQ0vsC7SZBXVvPE/M3xF63B6fTWuTd8W7YJcMBKJSx/t1q5upng8QgprrZxVIBb5Vw+vPVgZWTp6XLifImvXihBBDnVVSeotgEgsix3C7OoI5dLqMeMgSnJP+pvucjjNkv/dA9etXR1mSR6woDQp3nBhvQweOgVW5gB9q+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752000415; c=relaxed/simple;
	bh=LW/PGa6n7mpeqW4WnIqrH5O5XGvVTDBQddHMK8ZzHrg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=TRq4xC3WP2JZ3LyYFhnQJLz/nJwebSaYo0/2araZuAGMOxeUih5TSgjlQc0UqSi/GPZL+20VXXz0bMkguUhbhQwu76aWsl59gC2AhrKvfiMmFotFFPzzibPC+cfbe6RrEioYk0S55sdzZ2qpaLct5SoCIBPYV4Grcblp7aJMo1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAC8556772;
	Tue,  8 Jul 2025 18:38:19 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 72B362002A;
	Tue,  8 Jul 2025 18:38:18 +0000 (UTC)
Date: Tue, 8 Jul 2025 14:38:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Julia Lawall <Julia.Lawall@inria.fr>
Subject: [PATCH] trace-cmd split: Only open one file descriptor per CPU
Message-ID: <20250708143819.09124bd7@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 72B362002A
X-Stat-Signature: jnnsuugobaxxtos9deycft48optcrg8h
X-Rspamd-Server: rspamout06
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+uhZs6wll3a+gWvy73h66dTfRiJqnLSjg=
X-HE-Tag: 1751999898-2479
X-HE-Meta: U2FsdGVkX1+I9RrmDyxjvOdAYovvb2E85n8Dd8vR8fg/hd2mpdNQuxW8Q4GS9CO84YDEwpflH2r+u4Sf48Z3u4CU0J7RZyaUNXll9RC/+1nZCUvOb75ArOGZDmATD6bWOIC69h2QLc3fyDpHiUE0qTI7HIHvNgajUeh9U5WJRRQASpT7BTV4I23LQlv/WO+o4sE4qyapWqEaX4WtF9l26F6ZJE54qKPrAwIwQEjQm0OqA6dsny5McAHKI9cfi2aV214qkcrlSfzytqLUTwtR9ODyvnbv4xS5STa2GmmcP7zSOnkjNkFXPi1AvG+dKuQeyluly6Q8Nr6kwy2Qx5YV+4pLyWi3IfdK6XA8E2rAMP9kf/UZ611JUfCq632jhx55

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

When splitting a trace.dat file, trace-cmd split will create a temp file
per CPU as it parse the trace.dat to store what to save in the new
trace.dat file into per CPU files.

After it finishes the creation of the CPU data files, it then calls
tracecmd_append_cpu_data() which will open each of these CPU files and
append them to the new trace.dat file.

The issue is when you have a trace.dat file that was created by a machine
with 512 CPUs. Because it doesn't close the file descriptors after
creating the files and before calling tracecmd_append_cpu_data() it has
1024 file descriptors open. With some distributions having a file
descriptor limit of 1024, this exceeds the limit because there's other
file descriptors open (for the trace.dat files themselves), and the
program fails.

There's no reason to keep the file descriptors open for the files that
were created before calling tracecmd_append_cpu_data(). Just close them
before calling that function. This keeps the number of file descriptors
open to that of the number of CPU buffers in the trace.dat file instead of
doubling them. There is a couple more file descriptors open as mentioned
before, but those are not an issue.

Reported-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-split.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 13a10c89590d..e037ab491ba0 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -571,6 +571,11 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 				  end, count, percpu, -1, type, &curr_end_reached);
 		}
 
+		for (cpu = 0; cpu < cpus; cpu++) {
+			close(cpu_data[cpu].fd);
+			cpu_data[cpu].fd = -1;
+		}
+
 		/* End is reached when all instances finished. */
 		all_end_reached &= curr_end_reached;
 
@@ -599,7 +604,6 @@ static unsigned long long parse_file(struct tracecmd_input *handle,
 		}
 
 		for (cpu = 0; cpu < cpus; cpu++) {
-			close(cpu_data[cpu].fd);
 			delete_temp_file(cpu_data[cpu].file);
 			put_temp_file(cpu_data[cpu].file);
 		}
-- 
2.47.2

