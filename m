Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7E219F401
	for <linux-trace-devel@vger.kernel.org>; Mon, 14 Oct 2024 12:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728909108; cv=none; b=Aoon5Ba1DyWPPxQ+KeuN0SuQoDNRN55nEmykQENvgu+gP/AuAYyKYQ7z43f6P2NaA7XaxOjx2E0KQCcHmWsDkTIZb+/1ODh8jJIHVxrN2moOmvXjjoZSeEr4FdRq8CIn2Btg6jUrBcy6bvtgxnNwtXOfXA5wMF7STKMCJWxr54k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728909108; c=relaxed/simple;
	bh=y6ZXetTADlWhaEZn8sIhap+eTKJulZ1JxkaFsz5xp94=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tzztI+fnWf3tpgOgWnxhm6iPI21DKpTBL4Y+8lZdElzUXwx9hl0xldTIZF0DmNTIjzkEhLJnr4NKhiqIfzJJP1za4+mqQmVoO5lB1dNO42AHs5G88QJxKMRMwTZepiL9RqJ4IPTFHkKu+zqe2Or2iHjAeP8a0OVb4z4eJ3as/LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78D971007;
	Mon, 14 Oct 2024 05:32:15 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4B6B63F71E;
	Mon, 14 Oct 2024 05:31:45 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com
Subject: [PATCH v2 0/4] trace-cmd reset: Add option to preserve specific events
Date: Mon, 14 Oct 2024 13:31:32 +0100
Message-Id: <20241014123136.3890807-1-metin.kaya@arm.com>
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

    trace-cmd version 3.3.1 (841c96c66b529d52bfce9e84a533fa904ba954ed)

    usage:
     trace-cmd reset [-b size][-B buf][-k event][-a][-d][-t]
              Disables the tracer (may reset trace file)
              Used in conjunction with start
              -b change the kernel buffer size (in kilobytes per CPU)
              -d delete the previous specified instance
              -B reset the given buffer instance (may specify multiple -B)
              -a reset all instances (except top one)
              -t reset the top level instance (useful with -B or -a)
              -k keep dynamic event during reset (can be specified multiple times).
                  Valid values are:
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

Changes since v1:
- Update man page for -k command line parameter of "trace-cmd reset".
- Add tab completion support for "trace-cmd reset".

[1] https://bugzilla.kernel.org/show_bug.cgi?id=219302

Metin Kaya (4):
  trace-cmd reset: Bail out immediately if user provides an invalid
    option
  trace-cmd reset: Add option to preserve specific dynamic events
  trace-cmd reset: Update man page for -k option
  trace-cmd reset: Add bash tab completion for -B and -k

 Documentation/trace-cmd/trace-cmd-reset.1.txt | 12 +++-
 tracecmd/trace-cmd.bash                       | 31 ++++++++++
 tracecmd/trace-record.c                       | 62 +++++++++++++++++--
 tracecmd/trace-usage.c                        |  6 +-
 4 files changed, 103 insertions(+), 8 deletions(-)

-- 
2.34.1

