Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D081B78F3
	for <linux-trace-devel@vger.kernel.org>; Thu,  4 Dec 2025 21:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764883341; cv=none; b=cRpMHK2V63gmJrJIEaM0ViixZIIbzZYL+5keRqPiGjv41eZphnJmyHdKZowx4nlOygY1FPMFx6WP7mgJ0Rg2kho5+iSJENMDbreE33Zqv2oY8IRO9QFJLj9YF7jOQOtCQxSYnB6ItqDEA4WqWtSnIKtHHyqkEPewY9SIfzoKu9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764883341; c=relaxed/simple;
	bh=A0k1g0OtneAoBPxigU1g2lQcb02rXN8objAqFYWE3Os=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s7wUn7lT0Jwc77p2Q9dpXnl/ehpYR36IrHCQV2LyW9FdSi+nDaPECzRjJ8qO8zLmMBFBozfIVlH6kYlIGNvH4HNqNM93rcwBQmyw2lLEcRH3jCMAJPYfALJPzub3I51AHSvYjk8qtidSmFSsmbeHuHAjdVZ/1623ABUeT1ojfiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE06F16024F;
	Thu,  4 Dec 2025 21:22:06 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id 6FF621E;
	Thu,  4 Dec 2025 21:22:05 +0000 (UTC)
Date: Thu, 4 Dec 2025 16:23:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] tracecmd: --poll option is not passed down to guest
Message-ID: <20251204162310.745aeab8@gandalf.local.home>
In-Reply-To: <aPu6yVSp0BtyNXc2@tpad>
References: <aPu6yVSp0BtyNXc2@tpad>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5u8jjohz3iqajkkekob9kaoys8qriz7z
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 6FF621E
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/UQVhEPiT6dPWn/Y7c1PM7lITF70CuiM0=
X-HE-Tag: 1764883325-493812
X-HE-Meta: U2FsdGVkX1+taFXvZ81kBXVYfoAy/vIOf5pnrOWI2gm0koXPM2mlwGaxME7cwgMMNSE8kih8x1mKMOoQDtHS0uUGrt0m0xS75eoD4flC3Ea4KvyVaKYqJG9RT8GpNK0S2YYI7PaYn+KWVRvDNUDxo1R8LiJpKyD5n/PvcYbI+5llXEtCNK1D4sFMFYKDh8icdzbpBbYWTaWgWfwDHycob/FiKjcqXALWoGtzVI4+XPYr4bDQP2Iq8/LI0NyJFWn/lO1strha9wGG2Rydj5Fssyyh8JtiQgLvjEWATLF8tzShj462kA/Z06UMZ/iEh/8s1zB9ylx8fRDQj+VylfKxOLgjF+ViBdmc

On Fri, 24 Oct 2025 14:43:37 -0300
Marcelo Tosatti <mtosatti@redhat.com> wrote:

Hi Marcelo,

Sorry for the late reply. Unfortunately, trace-cmd updates is usually my
low priority task :-/

> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -6220,9 +6220,16 @@ static void add_arg(struct buffer_instance *instance,
>  {
>  	char *ptr, *arg;
>  	int i, ret;
> +	int long_opt;
> +
> +	long_opt = 0;
> +	for (i = 0; long_options[i].name; i++) {
> +		if (long_options[i].val == c)
> +			long_opt = 1;
> +	}

I hate looking at every long option to determine if this is a long option
or not.

>  
>  	/* Short or long arg */
> -	if (!(c & 0x80)) {
> +	if (long_opt == 0) {
>  		ptr = strchr(opts, c);
>  		if (!ptr)
>  			return; /* Not found? */

What about this patch?

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4e1157c99294..29938b1bb701 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5932,36 +5932,39 @@ void init_top_instance(void)
 	init_instance(&top_instance);
 }
 
+#define LONG_OPT(opt)		(0x80 + ((opt) << 8))
+#define IS_LONG_OPT(opt)	((opt) & 0x80)
+
 enum {
-	OPT_compression		= 237,
-	OPT_file_ver		= 238,
-	OPT_verbose		= 239,
-	OPT_tsc2nsec		= 240,
-	OPT_fork		= 241,
-	OPT_tsyncinterval	= 242,
-	OPT_user		= 243,
-	OPT_procmap		= 244,
-	OPT_quiet		= 245,
-	OPT_debug		= 246,
-	OPT_no_filter		= 247,
-	OPT_max_graph_depth	= 248,
-	OPT_tsoffset		= 249,
-	OPT_bycomm		= 250,
-	OPT_stderr		= 251,
-	OPT_profile		= 252,
-	OPT_nosplice		= 253,
-	OPT_funcstack		= 254,
-	OPT_date		= 255,
-	OPT_module		= 256,
-	OPT_nofifos		= 257,
-	OPT_cmdlines_size	= 258,
-	OPT_poll		= 259,
-	OPT_name		= 260,
-	OPT_proxy		= 261,
-	OPT_temp		= 262,
-	OPT_notimeout		= 264,
-	OPT_daemonize		= 265,
-	OPT_subbuf		= 266,
+	OPT_compression		= LONG_OPT(0),
+	OPT_file_ver		= LONG_OPT(1),
+	OPT_verbose		= LONG_OPT(2),
+	OPT_tsc2nsec		= LONG_OPT(3),
+	OPT_fork		= LONG_OPT(4),
+	OPT_tsyncinterval	= LONG_OPT(5),
+	OPT_user		= LONG_OPT(6),
+	OPT_procmap		= LONG_OPT(7),
+	OPT_quiet		= LONG_OPT(8),
+	OPT_debug		= LONG_OPT(9),
+	OPT_no_filter		= LONG_OPT(10),
+	OPT_max_graph_depth	= LONG_OPT(11),
+	OPT_tsoffset		= LONG_OPT(12),
+	OPT_bycomm		= LONG_OPT(13),
+	OPT_stderr		= LONG_OPT(14),
+	OPT_profile		= LONG_OPT(15),
+	OPT_nosplice		= LONG_OPT(16),
+	OPT_funcstack		= LONG_OPT(17),
+	OPT_date		= LONG_OPT(18),
+	OPT_module		= LONG_OPT(19),
+	OPT_nofifos		= LONG_OPT(20),
+	OPT_cmdlines_size	= LONG_OPT(21),
+	OPT_poll		= LONG_OPT(22),
+	OPT_name		= LONG_OPT(23),
+	OPT_proxy		= LONG_OPT(24),
+	OPT_temp		= LONG_OPT(25),
+	OPT_notimeout		= LONG_OPT(26),
+	OPT_daemonize		= LONG_OPT(27),
+	OPT_subbuf		= LONG_OPT(28),
 };
 
 void trace_stop(int argc, char **argv)
@@ -6222,7 +6225,7 @@ static void add_arg(struct buffer_instance *instance,
 	int i, ret;
 
 	/* Short or long arg */
-	if (!(c & 0x80)) {
+	if (!IS_LONG_OPT(c)) {
 		ptr = strchr(opts, c);
 		if (!ptr)
 			return; /* Not found? */


-- Steve

