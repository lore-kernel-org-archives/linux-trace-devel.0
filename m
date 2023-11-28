Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C8046B83;
	Tue, 28 Nov 2023 20:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D64EC433C8;
	Tue, 28 Nov 2023 20:18:01 +0000 (UTC)
Date: Tue, 28 Nov 2023 15:18:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Vernet <void@manifault.com>
Cc: linux-trace-devel@vger.kernel.org, linux-trace-users@vger.kernel.org,
 kernel-team@meta.com, julia.lawall@inria.fr, himadrispandya@gmail.com
Subject: Re: [PATCH] trace-cmd record: Reset PATH variable after strtok
 search
Message-ID: <20231128151823.185839b8@gandalf.local.home>
In-Reply-To: <20231128201302.GB431764@maniforge>
References: <20231128192435.36507-1-void@manifault.com>
	<20231128143044.72f0925e@gandalf.local.home>
	<20231128200856.GA431764@maniforge>
	<20231128201302.GB431764@maniforge>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Nov 2023 14:13:02 -0600
David Vernet <void@manifault.com> wrote:
> > > > 
> > > > Fixes: edf9424029cc ("trace-cmd: Open code execvp routine to avoid multiple execve syscalls")
> > > > Signed-off-by: David Vernet <void@manifault.com>
> > > > ---
> > > >  tracecmd/trace-record.c | 8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > > 
> > > > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > > > index bced80406816..63af11ecaa80 100644
> > > > --- a/tracecmd/trace-record.c
> > > > +++ b/tracecmd/trace-record.c
> > > > @@ -1708,6 +1708,14 @@ static void execute_program(int argc, char **argv)
> > > >  				break;
> > > >  
> > > >  		}
> > > > +
> > > > +		/*
> > > > +		 * reset PATH to saveptr, as strtok_r overwrites the string
> > > > +		 * returned by getenv() which backs the PATH environment
> > > > +		 * variable.
> > > > +		 */
> > > > +		if (setenv("PATH", saveptr, 1))
> > > > +			die("Failed to reset PATH to %s (%s)", saveptr, strerror(errno));
> > > >  	} else {
> > > >  		strncpy(buf, argv[0], sizeof(buf));
> > > >  	}  
> > > 
> > > The fix I had was this:
> > > 
> > > 
> > > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > > index bced8040..1a461631 100644
> > > --- a/tracecmd/trace-record.c
> > > +++ b/tracecmd/trace-record.c
> > > @@ -1698,6 +1698,9 @@ static void execute_program(int argc, char **argv)
> > >  		if (!path)
> > >  			die("can't search for '%s' if $PATH is NULL", argv[0]);
> > >  
> > > +		/* Do not modify the actual environment variable */
> > > +		path = strdup(path);
> > > +
> > >  		for (entry = strtok_r(path, ":", &saveptr);
> > >  		     entry; entry = strtok_r(NULL, ":", &saveptr)) {
> > >  
> > > @@ -1712,6 +1715,7 @@ static void execute_program(int argc, char **argv)
> > >  		strncpy(buf, argv[0], sizeof(buf));
> > >  	}
> > >  
> > > +	free(path);  
> 
> Also, this should either be brought into the !strchr() branch, or path
> should be initialized to NULL.

yeah, that's probably why I haven't actually committed it yet (it's still
just a "diff" in my tree ;-)

> 
> > >  	tracecmd_enable_tracing();
> > >  	if (execve(buf, argv, environ)) {
> > >  		fprintf(stderr, "\n********************\n");
> > > 
> > > Does that work for you?  
> > 
> > That would work too, though I don't think strtok_r() is doing anything
> > useful at that point. IMO it's better to either do the setenv() with
> > saveptr, or change that strtok_r() to a regular strtok().

I always use strtok_r() over strtok() just because it's "safer"!

I know it's not necessary, but the number of times I had to switch it to
make the code thread safe, I just decided to always use it. Just my personal
preference.

-- Steve


> >   
> > > 
> > > Although, I still need to test the result of strdup().
> > > 
> > > -- Steve  

