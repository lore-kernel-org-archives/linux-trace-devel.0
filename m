Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE348200C4
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 20:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA51C433C8;
	Mon,  2 Oct 2023 20:15:34 +0000 (UTC)
Date: Mon, 2 Oct 2023 16:16:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ross Zwisler <zwisler@google.com>
Cc: linux-trace-devel@vger.kernel.org, Stevie Alvarez
 <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 06/11] libtraceeval histogram: Add type to
 traceeval_data and make it a structure
Message-ID: <20231002161636.2352e27c@gandalf.local.home>
In-Reply-To: <20231002195304.GC1532181@google.com>
References: <20230927123314.989589-1-rostedt@goodmis.org>
	<20230927123314.989589-7-rostedt@goodmis.org>
	<20231002195304.GC1532181@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 2 Oct 2023 13:53:04 -0600
Ross Zwisler <zwisler@google.com> wrote:

> > -		}
> > +	struct traceeval_data keys[] = {
> > +		DEFINE_TRACEEVAL_CSTRING(	comm		),
> > +		DEFINE_TRACEEVAL_NUMBER(	RUNNING		),
> >  	};
> >  
> >  	for (int i = 0; i < OTHER; i++) {
> > -		keys[1].number = i;
> > +		TRACEEVAL_SET_NUMBER_64(keys[1], i);  
> 
> I think this should be 
> +		TRACEEVAL_SET_NUMBER(keys[1], i);
> 
> to match the 
> +		DEFINE_TRACEEVAL_NUMBER(	RUNNING		),
> 
> a little up in this function.

You're correct, and I already fixed it. Just haven't posted the fix yet.

-- Steve
