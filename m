Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74DF41C2EC
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Feb 2026 14:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217121; cv=none; b=Oxx3pQSC/gzlt0qN4WzHDMFFsGIHkk747Lu+4meQqKM1nXHphqzs8sNdu94n3QzmJDWoHZ70mzJnXGMUEqUjxsNMAxD4ffpKBDGBaBF5qikCypbPxIlIQ5v8B12N2DRLToi8a18fB1QQjtqFJVfdpFReXAN1Ci9he2vdjxPKppQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217121; c=relaxed/simple;
	bh=PxzuNEDtSjUx2CrCThMnnFYt7YGgmxMYzI7gMst4zTc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=IPRABEow7iKkY3msdi15J/qxd0bhuObPly+D71sAQtMKCutIFV53u7ubgADoZVHxGrfVGElgjbGyZuoCuh3DYsEREfF06COLLZafr0qHpSVtw5UGnoLh/2tl99ffp9LGCzOpxkcl/ncThehl2kCFuOdNSvOhXPA8STYjTs7h2FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aDL6+jX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDL6+jX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852E9C4CEF7;
	Wed,  4 Feb 2026 14:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770217120;
	bh=PxzuNEDtSjUx2CrCThMnnFYt7YGgmxMYzI7gMst4zTc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aDL6+jX1HAyhFcjdzvH22NmWzbcJR2GZcbAZr/EzhVI3RkUvzMup1s1Q0JhWgp6+s
	 4D60pu7giI2rwUXTv9dHWAzHZ2QT8I8+qIYNt2dfMNl4lj/P9BznwH/XmiorAP9Wol
	 NkXmVptghZ5KTgtQHrnfikGPIth9R88I9j6/kS6y7JzThnh4JmHvdK9EB74wGUKZz1
	 GCQPbaiBe6TAthBjrl30LHL1nm7fVCmcrh9Cg6mFk5jL8Ou+zfeScrC+J4emf6FPA4
	 MkPkzsE3OoW+jCj5vxlWZBFKIPJJb+F9tRpJfxOwZADnnKDACH1zo41AvaN/ai5FcU
	 ptvOKkIZGLk5g==
Date: Wed, 4 Feb 2026 23:58:37 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Masami Hiramatsu
 <mhiramat@kernel.org>
Subject: Re: [PATCH 0/2] trace-cmd record: Handle persistent ring buffers
Message-Id: <20260204235837.71ccaa2f4356c598e5f43f42@kernel.org>
In-Reply-To: <20260204012244.2135465-1-rostedt@goodmis.org>
References: <20260204012244.2135465-1-rostedt@goodmis.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  3 Feb 2026 20:18:04 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Now that a ring buffer instance can be from a previous boot, allow trace-cmd
> to be able to read its content and still get the function names from the
> addresses.
> 
> If a persistent ring buffer is from a previous boot, it will have a
> "last_boot_info" file. This contains the address of the _text section of the
> core kernel as well as where all the modules were loaded. This can be used
> to calculate the addresses in the previous boot ring buffer to the addresses
> in the current kallsyms to find out the name of the function an address
> belongs to.
> 
> Also if the last_boot_info file exists, the /proc/modules file is read. This
> is because functions in modules needs to have its address calculated from
> where its module was loaded in the previous boot to where it is loaded in
> the current boot. The last_boot_info contains the addresses of the modules
> of the previous boot, and /proc/modules contains the addresses of the
> modules from the current boot. With both the addresses of functions in
> modules can be converted to the corresponding address in kallsyms.
> 

Both looks good to me. BTW, both only records the information, and
resolving symbol will be the next series?

Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

for the series.

Thank you,

> Steven Rostedt (Google) (2):
>   trace-cmd record: Handle last_boot_info file
>   trace-cmd record: Add section for /proc/modules
> 
>  .../trace-cmd/trace-cmd.dat.v7.5.txt          | 31 +++++++++--
>  .../include/private/trace-cmd-private.h       |  3 ++
>  lib/trace-cmd/trace-ftrace.c                  |  4 +-
>  lib/trace-cmd/trace-input.c                   | 31 +++++++++++
>  lib/trace-cmd/trace-output.c                  | 32 ++++++++++++
>  tracecmd/include/trace-local.h                |  2 +
>  tracecmd/trace-dump.c                         | 32 ++++++++++++
>  tracecmd/trace-record.c                       | 52 +++++++++++++++++++
>  8 files changed, 180 insertions(+), 7 deletions(-)
> 
> -- 
> 2.51.0
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
