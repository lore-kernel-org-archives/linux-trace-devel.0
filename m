Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986431F9EB9
	for <linux-trace-devel@vger.kernel.org>; Tue, 15 Oct 2024 17:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729013911; cv=none; b=UAUVg3+aWjQqiAQt5T/oQJyiutBfWlC3Q2alGJIer7r64RyCbbwPbXJJ565ckgAiOIsQvC81XpR8JXmowhWcDwY41ln0VmeH+aPUfHxBwefPa15Ht/tLc3po74cCV9Im3Y+dAIC2jsT4WHvJyXoV20olP4hrpXre1hIt9YPQlvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729013911; c=relaxed/simple;
	bh=0aQRdGaWRYUv+tWEtgaVlQKbMFy3HRMMQ3MoGECT9oY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hH/LxLDJ/IolKvMc7VrcSMK9rBqHmuH3iFCwDKgTBvY7PTLJNA5zFnSij/ykQy9wvlmmd9NS1YLikLBnyVLeKlPkpuR/DxDHBb25at6mxSEIxxcMZHngRzU0G1xIfiJEqsqe/1pYGPgNmff+GLnRsIedOEWRi7C0mw7MCm89jOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5547C4CEC6;
	Tue, 15 Oct 2024 17:38:30 +0000 (UTC)
Date: Tue, 15 Oct 2024 13:38:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd utest: Add test cases for trace-cmd reset
Message-ID: <20241015133849.1d3f3bf6@gandalf.local.home>
In-Reply-To: <20241015123831.347ff0f4@gandalf.local.home>
References: <20241015140840.4183007-1-metin.kaya@arm.com>
	<20241015123831.347ff0f4@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Oct 2024 12:38:31 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > +
> > +	/* Ensure the kretprobe is listed in "trace-cmd stat" output. */
> > +	ret = grep_match("r128:kprobes/r_do_sys_open_0 do_sys_open", "stat", NULL);  
> 
> Note, this failed for me, because mine had "r16:kprobes..."

BTW, this works though:

	ret = grep_match("r[0-9]*:kprobes/r_do_sys_open_0 do_sys_open", "stat", NULL);  

-- Steve
