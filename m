Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1A31E492;
	Wed, 17 Jul 2024 17:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239082; cv=none; b=VeM+BMEdZwm8if3E2VpDWcOG5dvFB+dGdmPlsN4iqVs9RpQMQfh7Mv0QQOZwUm0/y5weL+vg/vmdX9DuiQpryoIQ822f1Emq4TWpO7K2Cmc/oCZ08ryofuB0ojyIMIb4jNgnaGSMskJwWerkmEoEs2XXwvv1WZa8PuUwW9swqLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239082; c=relaxed/simple;
	bh=9iYshVzl+nwJ4N5UqzKnL5ul2j0+NrwmL2O8HGF3jzY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sKhp9i1F2jAZHoYk9RSH1CSypVgLjCj4o49XJOMP/APWBFa61Q+C+O5e19/ym0cuWuC0e4dbVZqXQl1lYSfrJb4ZBFsZ86/HQMjooppfwygOt2os7haiWYMC3YEFZB+RbMcM6A9/pMUlT/Fxf7taxD5QHee1dusaRbi6vxdVCZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0F4C2BD10;
	Wed, 17 Jul 2024 17:58:00 +0000 (UTC)
Date: Wed, 17 Jul 2024 13:57:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Guilherme Amadio <amadio@gentoo.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Arnaldo Carvalho de Melo
 <acme@kernel.org>, Ian Rogers <irogers@google.com>, Thorsten Leemhuis
 <linux@leemhuis.info>, Leo Yan <leo.yan@arm.com>,
 linux-perf-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] perf build: libtraceevent, libtracefs feature
 check with pkg-config
Message-ID: <20240717135759.37cf1bcf@rorschach.local.home>
In-Reply-To: <20240717174739.186988-1-amadio@gentoo.org>
References: <20240717123147.17169873@rorschach.local.home>
	<20240717174739.186988-1-amadio@gentoo.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 Jul 2024 19:47:34 +0200
Guilherme Amadio <amadio@gentoo.org> wrote:

> There is no change in this new submission relative to the last (which has been
> tested by Thorsten to fix the build issue in Fedora). The only change has been
> to add in CC Steven Rostedt and the list linux-trace-devel@vger.kernel.org.

Thanks,

For the whole series:

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Feel free to take it through the perf tree.

-- Steve

> 
> Best regards,
> -Guilherme
> 
> Guilherme Amadio (5):
>   perf build: Warn if libtracefs is not found
>   tools: Make pkg-config dependency checks usable by other tools
>   tools/verification: Use pkg-config in lib_setup of Makefile.config
>   tools/rtla: Use pkg-config in lib_setup of Makefile.config
>   tools/latency: Use pkg-config in lib_setup of Makefile.config
> 
>  tools/build/Makefile.feature          | 18 ++++++++++++++++++
>  tools/perf/Makefile.config            | 13 +++++--------
>  tools/tracing/latency/Makefile.config |  3 ++-
>  tools/tracing/rtla/Makefile.config    |  3 ++-
>  tools/verification/rv/Makefile.config |  3 ++-
>  5 files changed, 29 insertions(+), 11 deletions(-)
> 

