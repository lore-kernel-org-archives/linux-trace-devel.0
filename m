Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECF564A98
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Apr 2025 12:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744894352; cv=none; b=dqalQXbagilmaZ3iJb11jl6AggKiGRtNYM6K+nt6Ch2HPlW80nVhhh6Z4jjypJaWhB5+EC9Zwy2S2h38RZzJ/41EDIH58qDdpm6seZ69NrrXvPg8LYYqDkJwFRVVpvyHo8hZ56s8cfLI38tYv1ZDFoJHCDz99pmCBj24QQRVuyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744894352; c=relaxed/simple;
	bh=rQP5vxe5ETDA+OHT/wPzB2kPBchTIKN1bZQP2QhFWwA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U6Fea4vdCVeC2G5OVnKdCkNuxaZZsvFyB9e6d4IhGUHybvIT+GFjAcxLjSgcQEOH8RPU23pNrX/dF44uFDahuDe9r78gcg+eEsFcdlstZqwjXzV6LUJobjKwKjP7rN5B9wcfnb/EFlIal6M4AJcDv47u8FahaPAELRsrcFBjakk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2106C4CEE4;
	Thu, 17 Apr 2025 12:52:31 +0000 (UTC)
Date: Thu, 17 Apr 2025 08:54:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Malat <oss@malat.biz>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent plugins: Add plugin_net to handle bswap
 during print
Message-ID: <20250417085410.048431f0@gandalf.local.home>
In-Reply-To: <20250417074900.15044cc2@gandalf.local.home>
References: <20250409110705.437321-1-oss@malat.biz>
	<20250409225608.12df6ed8@gandalf.local.home>
	<20250414114117.6346acc3@gandalf.local.home>
	<CANMuvJmtk8bbQnT1FgnLzidQ_L1uGrdYypTRoyvLkJhUFVUi=g@mail.gmail.com>
	<20250417074900.15044cc2@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 17 Apr 2025 07:49:00 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> BTW, libtraceevent also provides its own swap functions so if the GCC
> builtin is not always available, then it should use that instead.
> 
>   See the "tep_data2host*()" fuctions.
> 
> But that may need to be updated as "tep_swapbytes*()" and have:
> 
> 	if (!tep || tep->host_bigendian != tep->file_bigendian)
> 		return data;

Something like this:

diff --git a/src/event-parse-api.c b/src/event-parse-api.c
index 8a0e976ade45..1897117142c9 100644
--- a/src/event-parse-api.c
+++ b/src/event-parse-api.c
@@ -106,52 +106,80 @@ bool tep_test_flag(struct tep_handle *tep, enum tep_flag flag)
 	return false;
 }
 
-__hidden unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data)
+static inline  unsigned short swap2(unsigned short data)
 {
-	unsigned short swap;
+	return ((data & 0xffULL) << 8) |
+		((data & (0xffULL << 8)) >> 8);
+}
 
+static inline  unsigned int swap4(unsigned int data)
+{
+	return ((data & 0xffULL) << 24) |
+		((data & (0xffULL << 8)) << 8) |
+		((data & (0xffULL << 16)) >> 8) |
+		((data & (0xffULL << 24)) >> 24);
+}
+
+static inline  unsigned long long swap8(unsigned long long data)
+{
+	return ((data & 0xffULL) << 56) |
+		((data & (0xffULL << 8)) << 40) |
+		((data & (0xffULL << 16)) << 24) |
+		((data & (0xffULL << 24)) << 8) |
+		((data & (0xffULL << 32)) >> 8) |
+		((data & (0xffULL << 40)) >> 24) |
+		((data & (0xffULL << 48)) >> 40) |
+		((data & (0xffULL << 56)) >> 56);
+}
+
+__hidden unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data)
+{
 	if (!tep || tep->host_bigendian == tep->file_bigendian)
 		return data;
 
-	swap = ((data & 0xffULL) << 8) |
-		((data & (0xffULL << 8)) >> 8);
-
-	return swap;
+	return swap2(data);
 }
 
 __hidden unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data)
 {
-	unsigned int swap;
-
 	if (!tep || tep->host_bigendian == tep->file_bigendian)
 		return data;
 
-	swap = ((data & 0xffULL) << 24) |
-		((data & (0xffULL << 8)) << 8) |
-		((data & (0xffULL << 16)) >> 8) |
-		((data & (0xffULL << 24)) >> 24);
-
-	return swap;
+	return swap4(data);
 }
 
 __hidden  unsigned long long
 tep_data2host8(struct tep_handle *tep, unsigned long long data)
 {
-	unsigned long long swap;
-
 	if (!tep || tep->host_bigendian == tep->file_bigendian)
 		return data;
 
-	swap = ((data & 0xffULL) << 56) |
-		((data & (0xffULL << 8)) << 40) |
-		((data & (0xffULL << 16)) << 24) |
-		((data & (0xffULL << 24)) << 8) |
-		((data & (0xffULL << 32)) >> 8) |
-		((data & (0xffULL << 40)) >> 24) |
-		((data & (0xffULL << 48)) >> 40) |
-		((data & (0xffULL << 56)) >> 56);
+	return swap8(data);
+}
+
+__hidden unsigned short tep_swapbytes2(struct tep_handle *tep, unsigned short data)
+{
+	if (tep && tep->host_bigendian != tep->file_bigendian)
+		return data;
+
+	return swap2(data);
+}
+
+__hidden unsigned int tep_swapbytes4(struct tep_handle *tep, unsigned int data)
+{
+	if (tep && tep->host_bigendian != tep->file_bigendian)
+		return data;
+
+	return swap4(data);
+}
+
+__hidden unsigned long long
+tep_swapbytes8(struct tep_handle *tep, unsigned long long data)
+{
+	if (tep && tep->host_bigendian != tep->file_bigendian)
+		return data;
 
-	return swap;
+	return swap8(data);
 }
 
 /**
diff --git a/src/event-parse-local.h b/src/event-parse-local.h
index d9e9faf649d1..cb2154547069 100644
--- a/src/event-parse-local.h
+++ b/src/event-parse-local.h
@@ -116,6 +116,10 @@ unsigned short tep_data2host2(struct tep_handle *tep, unsigned short data);
 unsigned int tep_data2host4(struct tep_handle *tep, unsigned int data);
 unsigned long long tep_data2host8(struct tep_handle *tep, unsigned long long data);
 
+unsigned short tep_swapbytes2(struct tep_handle *tep, unsigned short data);
+unsigned int tep_swapbytes4(struct tep_handle *tep, unsigned int data);
+unsigned long long tep_swapbytes8(struct tep_handle *tep, unsigned long long data);
+
 /* access to the internal parser */
 int tep_peek_char(struct tep_handle *tep);
 void tep_init_input_buf(struct tep_handle *tep, const char *buf, unsigned long long size);


-- Steve
