Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A1C187327
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2024 20:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721249911; cv=none; b=N7llkR8jo6pib9CjF4vHJr5r4R08f1AvBlempfnf2nyFXJfFdEPxSvyHSR3F/gYE6Bad6LsEum0oOQaZ8fZN1VRNC+IVzOe/FFNiI9nYpG8jNdMda0526J7J8pE3LpzkJBap+IGe6Y2Yv3h82nNPogKRCnU+uHrZP2+GMtmObGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721249911; c=relaxed/simple;
	bh=dy4Jg3NUHHGmlR0vwh3nvixqW/CK6d802WIlRTe1jlk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ahrcXT3UOZDJdJuMh26YJmVKaKP05lawzToSILcAgE6iscVAznahd6fUM6D6k4zJlk6FgzR8PKTVzh4Si9uY552ulAORF9+LeYSIvxLtJMuEtPSrTOEoRvML3NQVFIojm292dem/QkZnFCxS+aLiuYrmzhB5rTyjbu+wJbhU48o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B579C2BD10;
	Wed, 17 Jul 2024 20:58:30 +0000 (UTC)
Date: Wed, 17 Jul 2024 16:58:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jianfeng Wang <jianfeng.w.wang@oracle.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] trace-cmd: Add ftrace options for the fgraph
 retval feature
Message-ID: <20240717165828.61057625@rorschach.local.home>
In-Reply-To: <228cdfa6-29a5-4647-aefb-7fa04c1b1a00@oracle.com>
References: <20240521213730.67993-1-jianfeng.w.wang@oracle.com>
	<20240521213730.67993-3-jianfeng.w.wang@oracle.com>
	<20240717145028.73683d09@rorschach.local.home>
	<228cdfa6-29a5-4647-aefb-7fa04c1b1a00@oracle.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 Jul 2024 13:44:43 -0700
Jianfeng Wang <jianfeng.w.wang@oracle.com> wrote:

> On 7/17/24 11:50 AM, Steven Rostedt wrote:
> > On Tue, 21 May 2024 14:37:30 -0700
> > Jianfeng Wang <jianfeng.w.wang@oracle.com> wrote:
> >   
> >> Add two internal options for fgraph: fgraph:retval-skip and
> >> fgraph:retval-hex. By default, trace-cmd will print each function's
> >> return value at the function_graph exit point, if the kernel supports
> >> the fgraph-retval feature. If users want to skip the output of
> >> functions' return values, then set fgraph:retval-skip. Alternatively,
> >> users can set fgraph:retval-hex to force the return values to be
> >> printed in hex format.
> >>
> >> Here are example commands:  
> >>> trace-cmd report -O fgraph:retval-skip
> >>> trace-cmd report -O fgraph:retval-hex    
> > 
> > I would like to see a -O fgraph:retval-dec
> > 
> > As by default most is shown in hex, having an option to do that would
> > be great.
> > 
> > -- Steve
> > 
> >   
> 
> Hi Steve,
> 
> Sorry, I am confused about this.
> 
> Do you suggesting adding one more option fgraph:retval-dec or
> replacing fgraph:retval-hex with fgraph:retval-dec (and making the hex
> format as the default)?

I'd be happy to add both.

> 
> Currently, the patch prints return values in decimal by default
> (without any input), while users can specify fgraph:retval-hex to let
> numbers printed in hex.

It does?

I don't see that:

 $ trace-cmd report
[..]
           sleep-898   [006] ...1.   206.855186: funcgraph_entry:                   |  mutex_unlock() {
           sleep-898   [006] ...1.   206.855188: funcgraph_entry:        1.439 us   |    __mutex_unlock_slowpath(); (ret=0x0)
           sleep-898   [006] .....   206.855191: funcgraph_exit:         4.828 us   |  } (ret=0x0)
           sleep-898   [006] ...1.   206.855192: funcgraph_entry:        0.781 us   |  preempt_count_add(); (ret=0x202)
           sleep-898   [006] ...2.   206.855193: funcgraph_entry:                   |  rcu_read_lock_any_held() {
           sleep-898   [006] ...2.   206.855194: funcgraph_entry:        0.738 us   |    rcu_lockdep_current_cpu_online(); (ret=0x1)
           sleep-898   [006] ...1.   206.855195: funcgraph_exit:         2.243 us   |  } (ret=0x1)
           sleep-898   [006] ...2.   206.855196: funcgraph_entry:        0.814 us   |  preempt_count_sub(); (ret=0x2f3e8)
           sleep-898   [006] ...1.   206.855198: funcgraph_entry:                   |  __f_unlock_pos() {
           sleep-898   [006] ...1.   206.855199: funcgraph_entry:                   |    mutex_unlock() {
           sleep-898   [006] ...1.   206.855199: funcgraph_entry:        0.851 us   |      __mutex_unlock_slowpath(); (ret=0x0)
           sleep-898   [006] .....   206.855201: funcgraph_exit:         2.426 us   |    } (ret=0x0)
           sleep-898   [006] .....   206.855202: funcgraph_exit:         3.994 us   |  } (ret=0x0)

> >> @@ -235,8 +249,8 @@ print_graph_entry_leaf(struct trace_seq *s,
> >>  		ret = trace_seq_printf(s, " (%lld)", depth);
> >>  
> >>  	/* Return Value */
> >> -	if (ret && fgraph_retval_supported) {
> >> -		if (!IS_LINUX_ERR_VALUE(retval))
> >> +	if (ret && fgraph_retval_supported && !fgraph_retval_skip->set) {
> >> +		if (fgraph_retval_hex->set || !IS_LINUX_ERR_VALUE(retval))

It prints out hex if the value is not an error. Only errors show
decimal output.

-- Steve

> >>  			ret = trace_seq_printf(s, " (ret=0x%llx)", retval);
> >>  		else
> >>  			ret = trace_seq_printf(s, " (ret=%lld)", retval);
> >> @@ -385,8 +399,8 @@ fgraph_ret_handler(struct trace_seq *s, struct tep_record *record,
> >>  		trace_seq_printf(s, " (%lld)", depth);
> >>  
> >>  	/* Return Value */
> >> -	if (fgraph_retval_supported) {
> >> -		if (!IS_LINUX_ERR_VALUE(retval))
> >> +	if (fgraph_retval_supported && !fgraph_retval_skip->set) {
> >> +		if (fgraph_retval_hex->set || !IS_LINUX_ERR_VALUE(retval))
> >>  			trace_seq_printf(s, " (ret=0x%llx)", retval);
> >>  		else
> >>  			trace_seq_printf(s, " (ret=%lld)", retval);  
> >   

