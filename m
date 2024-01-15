Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF8418EB3
	for <linux-trace-devel@vger.kernel.org>; Mon, 15 Jan 2024 18:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649FAC433C7;
	Mon, 15 Jan 2024 18:56:55 +0000 (UTC)
Date: Mon, 15 Jan 2024 13:56:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 5/5] trace-cmd: split: Handle splitting files with
 multiple instances
Message-ID: <20240115135653.6c4ee8ff@rorschach.local.home>
In-Reply-To: <7f3739f5-4e68-4cf4-81f2-99f342a884d7@arm.com>
References: <20240112083945.1361293-1-pierre.gondois@arm.com>
	<20240112083945.1361293-6-pierre.gondois@arm.com>
	<20240112111816.26f2cd6b@gandalf.local.home>
	<7f3739f5-4e68-4cf4-81f2-99f342a884d7@arm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jan 2024 18:25:46 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> >   
> >> Make use of the previous patches to split all the instances of
> >> a trace.  
> > 
> > This shouldn't be in the change log. As the change log is for history.
> > Think about reading this 5 years from now. Would it make sense about
> > "previous patches"?  
> 
> I thought it was acceptable to do so as the previous patches would
> be just before in the git log, but ok I will write something better.

The thing is, what does the previous patches do that's important for
this change? If I see this in a change log, I may look at the previous
patches, but note that the order is not always the same. I could have
imported a patch with a date on it that happens to go between the two
and cause the history to be different. But that's usually in merged
commits which I avoid here, but still.

Sometimes in a change log I'll put:

 "Now that X was done, we can do Y"

Where X is done by previous patches, and if someone is curious, they
can go and see X. But just saying "Make use of previous patches"
doesn't tell me what those previous patches did. And going back and
looking at them, I still don't know exactly how those previous patches
are related to this change, except that it did some clean up work.

-- Steve
