Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17C31CD2C
	for <linux-trace-devel@vger.kernel.org>; Mon, 25 Nov 2024 23:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732576730; cv=none; b=YI4t+LaqTBkYX/dEaLrUJMuSF+iOUQxZSKOWe6rOCbQwUhJQwjAlD0w0jVdS6faSUBaYJKMcl1mcdliCQPLp2D5Cb/SjkqdkY4/UBs2hvgaeyzzlynO6cQiDDwa7y6XJIBcniLa1CZNAep6w20ktBZv8CseBuUZ6tqnzgstSYVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732576730; c=relaxed/simple;
	bh=XdmvhnGBA5F3vwL6JXfspy/mlKHixARIapXWkzt+Wsg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NBiUeRxoz9BwVqMMlQwHJOHZGJiJQCrHiWC/xyAirJXlt8DqH+t5fS9TLK9TOOJpcqkIV+PCWY6Uf0akpMEHQBsvqtQNuSvThKESHaCFycJJHButjlBG4pmpySgcDlDNUQdi891fvJyawIZfjSK4eboUnyi2ED2a3akvffjwH8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37D8C4CECE;
	Mon, 25 Nov 2024 23:18:49 +0000 (UTC)
Date: Mon, 25 Nov 2024 18:19:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: linux-trace-devel@vger.kernel.org, Douglas Raillard
 <douglas.raillard@arm.com>
Subject: Re: [PATCH v2] trace-cmd: libtracecmd: Rename private functions to
 fix static building
Message-ID: <20241125181937.39e44440@gandalf.local.home>
In-Reply-To: <16ca253d-4598-4ee9-9b92-4412a689f059@arm.com>
References: <20241119153300.1668429-1-metin.kaya@arm.com>
	<20241122164914.1ffdd809@gandalf.local.home>
	<16ca253d-4598-4ee9-9b92-4412a689f059@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 25 Nov 2024 11:50:16 +0000
Metin Kaya <metin.kaya@arm.com> wrote:

> >> @@ -199,8 +199,8 @@ static void agent_handle(int sd, int nr_cpus, int page_size,
> >>   	if (ret < 0)
> >>   		die("Failed to receive trace request");
> >>     
> >   
> >> -	tsync_proto = tracecmd_tsync_get_proto(tsync_protos, get_clock(argc, argv),
> >> -					       tsync_role);
> >> +	tsync_proto = tcmd_tsync_get_proto(tsync_protos, get_clock(argc, argv),
> >> +					   tsync_role);  
> > 
> > I'm fine with this change in general, except for converting any function
> > name that starts with "tracecmd_" that is in the tracecmd/ directory. Yes
> > it's marked as hidden, but these are functions that are not quite ready to
> > become API, but are planned to.
> > 
> > I used this as a general notation. If it starts with "tracecmd_" and marked
> > as __hidden, it means that it is still a WIP API. If it is marked with
> > "trace_" it is just a direct hook between trace-cmd and the libraries.
> > 
> > Care to send a v3?  
> 
> Will do, but there is no function starts with "tracecmd_" defined under 
> tracecmd/ directory. Should it be lib/trace-cmd/ instead?

No function should be defined under the tracecmd directory. I'm talking
about all functions used under the tracecmd directory.

> IOW, I should *not* rename the functions below. Correct?
> - tracecmd_copy_trace_data()
> - tracecmd_filter_free()
> - tracecmd_filter_get()
> - tracecmd_filter_match()
> - tracecmd_filter_set()
> - tracecmd_tsync_get_proto()

I think the only one of the above is tracecmd_tsync_get_proto().

-- Steve

