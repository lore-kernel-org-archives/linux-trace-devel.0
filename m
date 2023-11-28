Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD4819AD;
	Tue, 28 Nov 2023 12:09:00 -0800 (PST)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-1fa486a0e10so1746677fac.3;
        Tue, 28 Nov 2023 12:09:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701202139; x=1701806939;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NpEwRx180lJEfdxOukXyrbwOGtzRHrgrI+jNodDn/cw=;
        b=Llh23OZmiJCOQjIjznrAc7JqwEuXDulsJEAgmllskz119F4GwEIVRCgssoNTh7erSo
         Pqk9yzd19aKf0sTpJyst1/Aeryvr94rW2BlnJQsHPKLFe0APttc1xBTGr7L+97A8plAV
         Q58Cp7WlLvvN7aReWBbalxfDBoao2ddANIhosMlISurZm1JEjEKvfn9ONMHKEW5ILVKf
         u2QosotBCs3w09cMBTHqLeskF8Yc50vuLvJJnsJvGrlFlr6i33DyNI79ROAITAs1VF8d
         YzKlTT0c0NeLqRqLDOrliTwfO13fl7vsEuB/S9f8TJW4Ejjj48ucppq4YzCr2i5FfAVA
         iSbw==
X-Gm-Message-State: AOJu0Yz9UJ+SAIbuB4I8negjXdafznySG4XhTBeWkVYoTnxSNPyzsxjT
	lR5sDOi5MMN5LOdbO/z8g8U=
X-Google-Smtp-Source: AGHT+IEzGYXU5O9ibIq7s57grzlhJPTivNG5G/5shBi9EinhuCepHpHep9SuCfY7CfX+yTlWdJa6uw==
X-Received: by 2002:a05:6870:7020:b0:1f9:52e2:a8d7 with SMTP id u32-20020a056870702000b001f952e2a8d7mr19103856oae.43.1701202139231;
        Tue, 28 Nov 2023 12:08:59 -0800 (PST)
Received: from maniforge (c-24-1-27-177.hsd1.il.comcast.net. [24.1.27.177])
        by smtp.gmail.com with ESMTPSA id s12-20020a0cb30c000000b00679d4021621sm5387518qve.145.2023.11.28.12.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 12:08:58 -0800 (PST)
Date: Tue, 28 Nov 2023 14:08:56 -0600
From: David Vernet <void@manifault.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, linux-trace-users@vger.kernel.org,
	kernel-team@meta.com, julia.lawall@inria.fr,
	himadrispandya@gmail.com
Subject: Re: [PATCH] trace-cmd record: Reset PATH variable after strtok search
Message-ID: <20231128200856.GA431764@maniforge>
References: <20231128192435.36507-1-void@manifault.com>
 <20231128143044.72f0925e@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128143044.72f0925e@gandalf.local.home>
User-Agent: Mutt/2.2.12 (2023-09-09)

On Tue, Nov 28, 2023 at 02:30:44PM -0500, Steven Rostedt wrote:
> On Tue, 28 Nov 2023 13:24:35 -0600
> David Vernet <void@manifault.com> wrote:
> 
> > execute_program(), in the trace-cmd record subcommand, searches for a
> > command in PATH to create an absolute path to pass to execve. The
> > implementation uses strtok_r, which mutates the underlying string in
> > place by replacing ':' tokens with NULL bytes. This can and does cause
> > the PATH that's passed to execve to only contain the first entry to
> > PATH, which can cause issues such as the following:
> > 
> > [root@maniforge linus]# trace-cmd record -e sched -v -e sched_stat_runtime make clean
> > /bin/sh: line 1: uname: command not found
> > /bin/sh: line 1: sed: command not found
> > /bin/sh: line 1: head: command not found
> > /bin/sh: line 1: grep: command not found
> > /bin/sh: line 1: mkdir: command not found
> > ...
> > /bin/sh: line 1: mkdir: command not found
> > /bin/sh: line 1: mkdir: command not found
> > Makefile:681: arch//Makefile: No such file or directory
> > make: *** No rule to make target 'arch//Makefile'.  Stop.
> > 
> > We should be resetting the PATH variable to the string stored in the
> > saveptr argument to strtok_r.
> 
> Bah, I had this fixed locally, but never made pushed it up.
> 
> > 
> > Fixes: edf9424029cc ("trace-cmd: Open code execvp routine to avoid multiple execve syscalls")
> > Signed-off-by: David Vernet <void@manifault.com>
> > ---
> >  tracecmd/trace-record.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index bced80406816..63af11ecaa80 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -1708,6 +1708,14 @@ static void execute_program(int argc, char **argv)
> >  				break;
> >  
> >  		}
> > +
> > +		/*
> > +		 * reset PATH to saveptr, as strtok_r overwrites the string
> > +		 * returned by getenv() which backs the PATH environment
> > +		 * variable.
> > +		 */
> > +		if (setenv("PATH", saveptr, 1))
> > +			die("Failed to reset PATH to %s (%s)", saveptr, strerror(errno));
> >  	} else {
> >  		strncpy(buf, argv[0], sizeof(buf));
> >  	}
> 
> The fix I had was this:
> 
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index bced8040..1a461631 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -1698,6 +1698,9 @@ static void execute_program(int argc, char **argv)
>  		if (!path)
>  			die("can't search for '%s' if $PATH is NULL", argv[0]);
>  
> +		/* Do not modify the actual environment variable */
> +		path = strdup(path);
> +
>  		for (entry = strtok_r(path, ":", &saveptr);
>  		     entry; entry = strtok_r(NULL, ":", &saveptr)) {
>  
> @@ -1712,6 +1715,7 @@ static void execute_program(int argc, char **argv)
>  		strncpy(buf, argv[0], sizeof(buf));
>  	}
>  
> +	free(path);
>  	tracecmd_enable_tracing();
>  	if (execve(buf, argv, environ)) {
>  		fprintf(stderr, "\n********************\n");
> 
> Does that work for you?

That would work too, though I don't think strtok_r() is doing anything
useful at that point. IMO it's better to either do the setenv() with
saveptr, or change that strtok_r() to a regular strtok().

> 
> Although, I still need to test the result of strdup().
> 
> -- Steve
