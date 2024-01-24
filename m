Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8CC135411
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jan 2024 22:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706135863; cv=none; b=hh82xuYCByNb8rqz0gLvS97GNuJFoLPN6XDWdeseNwF/cnkeNSE0zFFdl7/uvR/X8ShsIIGdrHruhH+v97Q7DlgjQAUI5pSlMPLIBxfxPP1HAB9lA7/HFlipH0g22P4HIRve5WK1QOXePa8Tk7ALoPDhHdL3lxG7tBe3QWz5YuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706135863; c=relaxed/simple;
	bh=vrj4mKSxWgBy6huSIUHO4oPJsftQiB7CeMblAqDx3QQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KdRYh/Y8Il96r0xT8+gi4n7hbT4roAxtRq18i3oyHM+q6AMVt/QMdp1vstd1cwY9SEn12p1NvFsndCh7O2f4Ys8pSrVLmz6zYlLHUjbg+GouBu0wNZT2xL2aqHrzgKaieih2Pard2j06tFA8ORTimgCQTS80MZ7VZ9wyxlZrFt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03E0C433F1;
	Wed, 24 Jan 2024 22:37:41 +0000 (UTC)
Date: Wed, 24 Jan 2024 17:37:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 4/5] trace-cmd split: Enable support for buffer
 selection
Message-ID: <20240124173740.6d9e2287@gandalf.local.home>
In-Reply-To: <20240123134215.385415-5-pierre.gondois@arm.com>
References: <20240123134215.385415-1-pierre.gondois@arm.com>
	<20240123134215.385415-5-pierre.gondois@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


[ Replying to the correct version of the patch I tested ]

On Tue, 23 Jan 2024 14:42:14 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> The 'trace-cmd split' command conserves all buffers/instances
> of the input .dat file. Add support to select the instances to
> keep and to place as the top instance in an output .dat file.
> 
> Multiple .dat files can be generated with different combinations
> of the instances to keep. The first instance in the command line
> is selected as the top instance in an output .dat file.
> 
> For example, with a trace recorded with:
>   $ trace-cmd record -e sched_wakeup -B switch_instance \
>     -e sched_switch -B timer_instance -e timer

I tried this with a trace.dat file that has a instance called "tast" and it
didn't work. Note, the top instance had no data.

  $ trace-cmd split -i /work/traces/trace-tast.dat -o /tmp/trace-tast2.dat -B tast

  $ trace-cmd report /tmp/trace-tast2.dat
cpus=2
tast:        trace-cmd-3559  [001] 59413.154884: sched_waking:         comm=kworker/u4:2 pid=1324 prio=120 target_cpu=000
tast:        trace-cmd-3564  [000] 59413.154900: sched_switch:         trace-cmd:3564 [120] R ==> kworker/u4:2:1324 [120]
tast:        trace-cmd-3559  [001] 59413.154907: sched_switch:         trace-cmd:3559 [120] S ==> trace-cmd:3565 [120]
tast:     kworker/u4:2-1324  [000] 59413.154911: sched_waking:         comm=sshd pid=18725 prio=120 target_cpu=001
tast:     kworker/u4:2-1324  [000] 59413.154929: sched_switch:         kworker/u4:2:1324 [120] I ==> sshd:18725 [120]
tast:             sshd-18725 [000] 59413.155120: sched_waking:         comm=sslh-fork pid=18724 prio=120 target_cpu=001
tast:             sshd-18725 [000] 59413.155178: sched_waking:         comm=kworker/0:1 pid=815 prio=120 target_cpu=000
tast:             sshd-18725 [000] 59413.155189: sched_switch:         sshd:18725 [120] S ==> sslh-fork:18724 [120]
tast:        sslh-fork-18724 [000] 59413.155303: sched_switch:         sslh-fork:18724 [120] S ==> kworker/0:1:815 [120]

Still has "tast" as an instance and not the top.

-- Steve

> 
> Creating a test.dat file containing the top instance and
> the switch_instance:
>   $ trace-cmd split --top -B switch_instance -o test.dat
> 
> Creating a test.dat file containing the switch_instance as
> the top instance, and the initial top instance as an instance
> named 'old_top':
>   $ trace-cmd split -B switch_instance --top=old_top -o test.dat
> 
> Splitting all instances in different .dat files:
>   $ trace-cmd split --top -o top.dat -B switch_instance \
>     -o switch.dat -B timer_instance -o timer.dat
> 
> To achieve this, new 'struct name_list', 'struct output_file_list'
> structures are created, with associated functions.
> 
> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
> ---
