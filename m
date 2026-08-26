Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE0645A285
	for <linux-trace-devel@vger.kernel.org>; Wed, 26 Aug 2026 20:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787776674; cv=none; b=ETdONniFpcut8qlIa45eJyvOs+s8b4vX+JU+R0zCkYgaWGqkA1Tjg6UN6NMP2PUo6MhZJuW7VK5md3th2KcpcHDJFUog0+pK0ATQ8hYQBFnMoePBJgNGbmfL7dm2ux3rtTLEIHGTPUx+TTRo9HXjs5mfKisOuyhQoSUK/WExCRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787776674; c=relaxed/simple;
	bh=0ZdZjHkdZCaWnMJp1vqZia03PzNV50B4pUje4P7tYLM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f3aEb+oIWEn92GGxsNilhcEe6127ciaZ8b740vkV292Gp/oDYXNLbSNx1FKnNpwgnoOd99/a5yo/pJUluYYOLd+GnVMgF0ec/ULPQ1SICsX58oE6P6K8hpWZCltyIRtGsORUsVGcbd2W6pWpkPNuaflN/w06/VtOM+uGHxGOoec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b=4pW8uQzQ; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b="4pW8uQzQ"
Received: from omf14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D23E160224;
	Wed, 26 Aug 2026 20:37:45 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 091F430;
	Wed, 26 Aug 2026 20:37:43 +0000 (UTC)
Date: Wed, 26 Aug 2026 16:38:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Benjamin Drung <benjamin.drung@canonical.com>
Cc: linux-trace-devel@vger.kernel.org, Adrien Nader
 <adrien.nader@canonical.com>
Subject: Re: [PATCH] libtracefs utest: Only use online CPUs during tests
Message-ID: <20260826163829.06e04e1b@gandalf.local.home>
In-Reply-To: <20260605085448.2052357-1-benjamin.drung@canonical.com>
References: <20260605085448.2052357-1-benjamin.drung@canonical.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wodsbqofd6599gkdbg6am9ygfbsdnin6
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 091F430
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19Jr7g5ZTO7uwIGSWXf3EymzoYSqYzcJ50=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=u7oMa7hJeqGLCoxjRafXwIagogMn+xc8XPsCQueBHps=; b=4pW8uQzQtvFF+iGZoXuMIiDpvIaxHIJIzYrlPex6pvPgKCAhsG8i8K5je8Y/+gblG13feBe7fbVi/9vvoYgZwjV8+g1Z05mtUhbyvb2FjJ8z8RdaRKTSX94nVUQN2Q8fraSlBU+u97Hl/D2O9YXupomPFuGg+6ZB374YtgkAr0o=
X-HE-Tag: 1787776663-135359
X-HE-Meta: U2FsdGVkX1/qc6kyDpYBxGX/fQOZamTKpu4S+Yt1J/BFCA0BUM27sqF2siVBymX82qprlZX7vCtxaAoDuMyhyoYizNTqK6rzgYF0DA6lNrLxtkpBNqAtVPPUdMUScdsVxBZp9hGUO/pO9Gq+J212dnhu/rIntU+bMLB4ac6jqHos7fb9jHmKNY3RL/xAvzVmCOjBL/A0RxkhyC69fslVkl8rOdzecM3JZSL/I2Yc5snH0pGkm4jppCYmCEzneA5XL+0Er9UepyyPCEBNxx++xp7TNQaRJ25a/5Nuf9RPTZTwDnbEGThmwESu6b4S0qCmM6ys0ayx/vG1VcWtNaD9ievGUxoq39zLL7BDulFYpalcsocwodSp2JbY4SzNIdyQdxGae6ReQrQfEZ7pTzAZTnojRAy3WukB


Even though the patch is marked with "From: Adrien", it also needs your
Signed-off-by as you are the one sending it. That is, you need both
signatures.

Thanks,

-- Steve


On Fri, 05 Jun 2026 08:55:43 +0000
Benjamin Drung <benjamin.drung@canonical.com> wrote:

> From: Adrien Nader <adrien.nader@canonical.com>
> 
> We cannot do operations over offline cores. Virtual machines can
> routinely announce the presence of all of the host's cores and only make
> some of them online.
> 
> This change assumes that all the online CPUs are continuously numbered
> and start at 0. While this is not perfect, it is still an improvement
> and might be enough, especially considering this touches tests only.
> 
> Signed-off-by: Adrien Nader <adrien.nader@canonical.com>
> ---
>  utest/tracefs-utest.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
> index e3ff215..665c7d9 100644
> --- a/utest/tracefs-utest.c
> +++ b/utest/tracefs-utest.c
> @@ -181,7 +181,7 @@ static void save_affinity(void)
>  {
>  	int cpus;
>  
> -	cpus = sysconf(_SC_NPROCESSORS_CONF);
> +	cpus = sysconf(_SC_NPROCESSORS_ONLN);
>  	cpuset_save = CPU_ALLOC(cpus);
>  	cpuset = CPU_ALLOC(cpus);
>  	cpu_size = CPU_ALLOC_SIZE(cpus);
> @@ -216,7 +216,7 @@ static void test_iter_write(struct tracefs_instance *instance)
>  	int cpus;
>  	int ret;
>  
> -	cpus = sysconf(_SC_NPROCESSORS_CONF);
> +	cpus = sysconf(_SC_NPROCESSORS_ONLN);
>  	save_affinity();
>  
>  	path = tracefs_instance_get_file(instance, "trace_marker");
> @@ -243,7 +243,7 @@ static void test_iter_write(struct tracefs_instance *instance)
>  
>  static void iter_raw_events_on_cpu(struct tracefs_instance *instance, int cpu, bool snapshot)
>  {
> -	int cpus = sysconf(_SC_NPROCESSORS_CONF);
> +	int cpus = sysconf(_SC_NPROCESSORS_ONLN);
>  	cpu_set_t *cpuset = NULL;
>  	int cpu_size = 0;
>  	int check = 0;
> @@ -292,7 +292,7 @@ static void iter_raw_events_on_cpu(struct tracefs_instance *instance, int cpu, b
>  
>  static void test_instance_iter_raw_events(struct tracefs_instance *instance)
>  {
> -	int cpus = sysconf(_SC_NPROCESSORS_CONF);
> +	int cpus = sysconf(_SC_NPROCESSORS_ONLN);
>  	int ret;
>  	int i;
>  
> @@ -317,7 +317,7 @@ static void test_iter_raw_events(void)
>  
>  static void test_instance_iter_snapshot_events(struct tracefs_instance *instance)
>  {
> -	int cpus = sysconf(_SC_NPROCESSORS_CONF);
> +	int cpus = sysconf(_SC_NPROCESSORS_ONLN);
>  	int i;
>  
>  	iter_raw_events_on_cpu(instance, -1, true);

