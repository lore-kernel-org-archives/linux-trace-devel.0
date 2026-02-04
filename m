Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FAC37F0FB;
	Wed,  4 Feb 2026 19:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770233002; cv=none; b=jiAhs46X977SzSVethphKGT/owl6sPS8Yda4VUfb69ox3R5gPjHxfxGEk4P/drIjoJ2VMbJlHdkD96DDlRxOHhysR8FbYJvkmZP9+FoLcBsZE1PDNizumFO6x2RrOeLuAT2mRCpXiun0t8s34jN9HSa9m46LHsCcj3k3pebuNQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770233002; c=relaxed/simple;
	bh=UBfvN2wafXe3z5mU+W2ksqJgq3QpOjCjvpI7nSd8XcE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=Sia1B7RuCphGuxYbgA+Ts7veMUfNfmMnnGrBflJeRdv8iGw6sDBjeYS3Tpwp4xlZUANG87TygyEVTOFztSgD4CmUri4QYEU1vD/KJ+IfUC2Aoh9cgJB+Mh/EHx27C82QaxlSuyL/RoFFGPASUQ4hnyZMLF3fza4OR18m7u8z2j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA10757CFA;
	Wed,  4 Feb 2026 19:23:20 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id B213B80019;
	Wed,  4 Feb 2026 19:23:18 +0000 (UTC)
Date: Wed, 4 Feb 2026 14:23:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
 "linux-trace-users@vger.kernel.org" <linux-trace-users@vger.kernel.org>,
 Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>
Subject: [ANNOUNCE] libtraceevent 1.9 released!
Message-ID: <20260204142350.518f5e8c@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B213B80019
X-Stat-Signature: 97sutsbq9kotwfmxpjgxf1uytbhgbkus
X-Rspamd-Server: rspamout08
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19D9Z7Puu5T04dJhqsf23A4hGMO8BPhj2A=
X-HE-Tag: 1770232998-577224
X-HE-Meta: U2FsdGVkX1+LAN9nNJJaR4iAV5vqgU5FFCv4z4xB3/Q2nAGqaQKXygpwPnk9+YI6gmlGDNXTfj2fP8O7HyTSHxPitJE4mAbZgEbQ1AXm3Z3cWWJTTIHi9zIasUHCTOS+5ftW1Pm7Fg07Lm17SI9OzvKkRdG2BE141Gxh4Bh60pll6ESLanKFPeLGAeaZwzY/EMBaRqEdMri0FSJQ3AVCHnATYZTZXFEfUrPvc9pD+liaxBC7pklWqFoh0iODzrYCj3pyWuSUp6ef9dG0L7SskolqIRZpW88fODkqDx7MuWbhVyoYcluD0EDjo+aSdL3/

libtraceevent: 1.9.0

Changes since 1.8.6:

 New APIs:

  Addition of loading the BTF file (/sys/kernel/btf/vmlinux) into the tep
  handle to allow it to parse function parameters:

        cat-33501 [005] ..... 136155.767950: function:             __x64_sys_execve(regs=0xffffc9000e3eff58)
        cat-33501 [005] ..... 136155.767951: function:                getname_flags(filename=0x7ffe7d33f3d0, flags=0)
        cat-33501 [005] ..... 136155.767951: function:                getname_flags.part.0(7ffe7d33f3d0, 0, 0, 0, 0, 0)
        cat-33501 [005] ..... 136155.767951: function:                   kmem_cache_alloc_noprof(s=0xffff8881001d3800, gfpflags=0xcc0)
        cat-33501 [005] ..... 136155.767951: function:                      fs_reclaim_acquire(gfp_mask=0xcc0)
        cat-33501 [005] ..... 136155.767952: function:                      fs_reclaim_release(gfp_mask=0xcc0)

  tep_load_btf() - loads the raw BTF file and parses it.

  tep_btf_print_args() - parses the arguments of a given function with the
                         given parameters.

  tep_btf_list_args() - list the arguments of a given function to produce
                        its prototype.

 - Add API for persistent ring buffer processing:

  tep_parse_last_boot_info() - Reads and parses the last_boot_info file of a
                        persistent ring buffer from a previous boot. This
                        has the information to convert the addresses of
                        functions from the previous boot to the addresses of
                        the corresponding function of the current boot.

  tep_load_modules() - If last_boot_info is loaded, then /proc/modules
                       should also be loaded to compare where the addresses
                       of the modules were loaded in the last boot (found in
                       the last_boot_info) to where they are loaded in the
                       current boot. This is used to convert the addresses
                       of module functions from the last boot to the address
                       of their corresponding function in the current boot.

   The above functions are used to be able to convert the addresses of the
   functions from the previous boot to their corresponding functions of the
   current boot that the kallsyms came from. (see tep_parse_kallsyms())

 Updates:

 - Handle __get_stacktrace() in the print-fmt field that synthetic events
   can add when they have a stacktrace field.

