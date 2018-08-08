Return-Path: <SRS0=PkBc=KX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:43276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727748AbeHHUN3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Aug 2018 16:13:29 -0400
Date: Wed, 8 Aug 2018 13:52:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [RFC][PATCH 00/24] tools lib traceevent: Rename pevent to tep
 for preparation for library
Message-ID: <20180808135239.71ebd89d@gandalf.local.home>
In-Reply-To: <20180808155548.510187543@goodmis.org>
References: <20180808155548.510187543@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


Sorry for the messed up threading. I'm using quilt to send the email,
and it appears that Debian testing pulled in a broken version that
doesn't thread the patches properly. It was fixed over a year ago!

  http://git.savannah.nongnu.org/cgit/quilt.git/commit/?id=360b85e1f6b6d1aff5ada942fcee816e1ad7a13c

But Debian testing still has the broken version (and I just recently
updated to it!). I'll be reporting this to Debian.

I'll send out a v2 that fixes the threading. Sorry about this :-(

-- Steve
