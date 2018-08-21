Return-Path: <SRS0=yn/p=LE=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725732AbeHUGTQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Aug 2018 02:19:16 -0400
Date: Mon, 20 Aug 2018 23:01:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 02/24] trace-cmd: Rename struct pevent_record to struct
 tep_record
Message-ID: <20180820230100.75f63b21@vmware.local.home>
In-Reply-To: <20180820143505.11525-3-tz.stoyanov@gmail.com>
References: <20180820143505.11525-1-tz.stoyanov@gmail.com>
        <20180820143505.11525-3-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


Hi Tzvetomir,

Note, these were not pulled from the tip git tree. As the subject isn't
the same, nor is the change log (as the change log has links and Cc's
as the tags).

I know this is a bit tedious, but by pulling from tip, we see what in
trace-cmd was pulled from upstream.

You can do this by going to the tip tree:

 $ cd linux-tip.git
 $ git format-patch cbc49b25b9cf2~1..cbc49b25b9cf2 tools/lib/

Then editing the patch file paths to match trace-cmd's paths.

 $ cd ../trace-cmd.git
 $ git am <patch>

Then take this patch:

 $ patch -p1 < this.patch

Skip the parts that say:

  Reversed (or previously applied) patch detected!  Assume -R? [n] 

As they are already applied, and you should end up with the same
changes but with the original upstream patch.

To make sure of this, do this from a different branch

 $ git checkout -b upstream-changes <branch where trace-cmd upstream is>

apply the changes from tip, and then you can do

 $ git diff upstream-changes <the branch that has this patch series>

and it should be the same.

Does this make sense?

-- Steve


On Mon, 20 Aug 2018 17:34:43 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In order to make libtraceevent into a proper library, variables, data
> structures and functions require a unique prefix to prevent name space
> conflicts. That prefix will be "tep_" and not "pevent_". This changes
> the struct pevent_record to struct tep_record.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h      | 48 ++++++++--------
>  include/traceevent/event-parse.h   | 44 +++++++--------
>  kernel-shark-qt/src/libkshark.c    | 28 +++++-----
>  kernel-shark-qt/src/libkshark.h    |  4 +-
>  kernel-shark/include/trace-graph.h | 18 +++---
>  kernel-shark/include/trace-gui.h   |  4 +-
>  kernel-shark/kernel-shark.c        |  4 +-
>  kernel-shark/trace-dialog.c        |  4 +-
>  kernel-shark/trace-graph.c         | 16 +++---
>  kernel-shark/trace-plot-cpu.c      | 30 +++++-----
>  kernel-shark/trace-plot-task.c     | 60 ++++++++++----------
>  kernel-shark/trace-plot.c          |  4 +-
>  kernel-shark/trace-view-main.c     |  2 +-
>  kernel-shark/trace-view-store.c    | 14 ++---
>  lib/trace-cmd/trace-ftrace.c       | 20 +++----
>  lib/trace-cmd/trace-input.c        | 88 +++++++++++++++---------------
>  lib/traceevent/event-parse.c       | 36 ++++++------
>  lib/traceevent/parse-filter.c      | 24 ++++----
>  plugins/plugin_blk.c               |  2 +-
>  plugins/plugin_function.c          |  2 +-
>  plugins/plugin_futex.c             |  2 +-
>  plugins/plugin_hrtimer.c           |  4 +-
>  plugins/plugin_kmem.c              |  2 +-
>  plugins/plugin_kvm.c               | 14 ++---
>  plugins/plugin_mac80211.c          |  4 +-
>  plugins/plugin_sched_switch.c      |  6 +-
>  plugins/plugin_tlb.c               |  2 +-
>  python/ctracecmd.i                 | 12 ++--
>  tracecmd/include/trace-local.h     |  4 +-
>  tracecmd/trace-hist.c              | 20 +++----
>  tracecmd/trace-mem.c               |  8 +--
>  tracecmd/trace-profile.c           | 36 ++++++------
>  tracecmd/trace-read.c              | 34 ++++++------
>  tracecmd/trace-record.c            |  4 +-
>  tracecmd/trace-split.c             | 12 ++--
>  tracecmd/trace-stream.c            |  2 +-
>  36 files changed, 309 insertions(+), 309 deletions(-)
> 
