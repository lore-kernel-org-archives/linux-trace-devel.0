Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B010719AD73
	for <linux-trace-devel@vger.kernel.org>; Thu, 10 Oct 2024 08:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550440; cv=none; b=RN53Bjm03Q+lefpDNp4JsCS5Def8zNxpjtghe4Zu1G4cbCUaeaCZ0GOBJ0Asig0jAr6umxSG3PZiUvqE9bbafTDTXEEM/Uh3ktzgR+ugI0X5NKHMT77IyxNdGEQMgrraGLQrUh6c7SGZMjjqIGfDlXI4EMuwFinVklTBC9BIycw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550440; c=relaxed/simple;
	bh=o38wF5l+Qb0Rbg4K1LogFi/akq4pG/wRnR4gl7C+/Ik=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AtgANsBrwbjQlj54qeTevfXnzutVqviBsM5bz3DIhNGgDMyXpPq8mvFKEG1C5rAHHlQ7YQlTK2oGE+eAGe5HggQYHSqquX/eTJPwo3hz9kZ7kP8GZ45oZfGoUIV0s8DJ3+kXKwfQ7kyZqc1N/3N2HfYkh1ogCclwESXKvNcZ8iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3B72497;
	Thu, 10 Oct 2024 01:54:27 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 900193F64C;
	Thu, 10 Oct 2024 01:53:57 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com
Subject: [PATCH 0/2] trace-cmd reset: Add option to preserve specific events
Date: Thu, 10 Oct 2024 09:53:48 +0100
Message-Id: <20241010085350.3479149-1-metin.kaya@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We may want to preserve some of the dynamic events (e.g., kprobes)
during a "trace-cmd reset" in some cases as discussed at [1]. Thus,
introduce a new command line option to "trace-cmd reset" to permit
sustaining specified events across reset.

To implement the necessary support, address a corner case in command
line option parsing handler in "trace-cmd reset" first. Because all
dynamic events gets destroyed even if the user passes an invalid
parameter to "trace-cmd reset".

Here is an example usage with the new command line option (-k):

    # trace-cmd reset -h

    trace-cmd version 3.3.0 (e4047ab9dfe261402e487a825bf79d04f10f5544+)

    usage:
     trace-cmd reset [-b size][-B buf][-k event][-a][-d][-t]
              Disables the tracer (may reset trace file)
              Used in conjunction with start
              -b change the kernel buffer size (in kilobytes per CPU)
              -d delete the previous specified instance
              -B reset the given buffer instance (may specify multiple -B)
              -a reset all instances (except top one)
              -t reset the top level instance (useful with -B or -a)
              -k keep dynamic event during reset. Valid values:
                  'kprobe', 'kretprobe', 'uprobe', 'uretprobe',
                  'eprobe', 'synth' and 'all'.

    # Add kprobe and kretprobe for sys_open():
    $ echo 'p do_sys_open' > /sys/kernel/tracing/kprobe_events
    $ echo 1 > /sys/kernel/tracing/events/kprobes/p_do_sys_open_0/enable
    $ echo 'r do_sys_open' >> /sys/kernel/tracing/kprobe_events
    $ echo 1 > /sys/kernel/tracing/events/kprobes/r_do_sys_open_0/enable
    $ cat /sys/kernel/tracing/kprobe_events
    p:kprobes/p_do_sys_open_0 do_sys_open
    r128:kprobes/r_do_sys_open_0 do_sys_open

    # Issue reset, but keep kprobes and kretprobes ('-k all' would keep
    # all existing dynamic events):
    $ trace-cmd reset -k kprobe -k kretprobe
    $ cat /sys/kernel/tracing/kprobe_events
    p:kprobes/p_do_sys_open_0 do_sys_open
    r128:kprobes/r_do_sys_open_0 do_sys_open

    # Issue reset, but this time only keep kretprobes:
    $ trace-cmd reset -k kretprobe
    $ cat /sys/kernel/tracing/kprobe_events
    r128:kprobes/r_do_sys_open_0 do_sys_open

    # Don't preserve any dynamic event:
    $ trace-cmd reset
    $ cat /sys/kernel/tracing/kprobe_events
    $

[1] https://bugzilla.kernel.org/show_bug.cgi?id=219302

Metin Kaya (2):
  trace-cmd reset: Bail out immediately if user provides an invalid
    option
  trace-cmd reset: Add option to preserve specific dynamic events

 tracecmd/trace-record.c | 62 +++++++++++++++++++++++++++++++++++++----
 tracecmd/trace-usage.c  |  5 +++-
 2 files changed, 60 insertions(+), 7 deletions(-)

-- 
2.34.1

