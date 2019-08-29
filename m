Return-Path: <SRS0=kCFW=WZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF87FC3A59F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 15:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACF4D2341B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Aug 2019 15:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfH2PtR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Aug 2019 11:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbfH2PtQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 11:49:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D64F72166E;
        Thu, 29 Aug 2019 15:49:14 +0000 (UTC)
Date:   Thu, 29 Aug 2019 11:49:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] kernel-shark: Increase the size of the task hash
Message-ID: <20190829114913.5df4ced9@gandalf.local.home>
In-Reply-To: <b651e39a-6f32-fe59-36bf-224cad5bc649@gmail.com>
References: <20190828140016.3ce1be4f@gandalf.local.home>
        <b651e39a-6f32-fe59-36bf-224cad5bc649@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/kxQ/_qAO2dRwvk5eu2bI8cz"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

--MP_/kxQ/_qAO2dRwvk5eu2bI8cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thu, 29 Aug 2019 15:46:24 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> On 28.08.19 =D0=B3. 21:00 =D1=87., Steven Rostedt wrote:
> > From: Steven Rostedt (VMware) <rostedt@goodmis.org>
> >=20
> > When loading a data file that contained 100,000s of tasks, using a 256
> > bucket size hash crippled it. By increasing the hash to 2^16 (65536) it
> > solves the issue (still small enough not to waste too much memory).
> >=20
> > In the process, I changed the knuth_hash() in libkshark.c to use the 32
> > bit version and just have the key use what it needs: =20
>=20
> If the size the hash table is 65536 then the multiplicative hashing=20
> function has to multiply the key by a prime number which is closer to=20
> 65536 / 1.61803398875 (the so called "golden ratio" of the size).
> It makes no sense to multiply by a number that is several orders of=20
> magnitude bigger than the size of the hash table.
>=20
> >=20
> >    key =3D knuth_hash();
> >    key +=3D knuth_hash >> SHIFT;
> >    key &=3D (1 << SHIFT) - 1;
> >=20
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > ---
> > diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
> > index 4201fa02..41572e18 100644
> > --- a/kernel-shark/src/libkshark.c
> > +++ b/kernel-shark/src/libkshark.c
> > @@ -252,19 +252,19 @@ void kshark_free(struct kshark_context *kshark_ct=
x)
> >   	free(kshark_ctx);
> >   }
> >  =20
> > -static inline uint8_t knuth_hash(uint32_t val)
> > +static inline uint32_t knuth_hash(uint32_t val)
> >   {
> >   	/*
> > -	 * Small table hashing function adapted from Donald E. Knuth's 32 bit
> > +	 * Hashing function adapted from Donald E. Knuth's 32 bit
> >   	 * multiplicative hash.  See The Art of Computer Programming (TAOCP).
> >   	 * Multiplication by the Prime number, closest to the golden ratio of
> > -	 * 2^8.
> > +	 * 2^32.
> >   	 */
> > -	return UINT8_C(val) * UINT8_C(157);
> > +	return val * UINT32_C(2654435761); =20
>=20
> So according to my understanding of the idea in the book, this line=20
> should look look this:
>=20
> 	return UINT16_C(val) * UINT8_16(65537);

I just tested this (see attached patches, to try it yourself, I added
the two libtraceevent fixes too). The results are *exactly* the same!

It's the prime number multiplication that is important.

They both give:

max=3D15441999 min=3D435 total=3D139895258 avg=3D2134 std2=3D55927

(since I didn't feel like adding a math library, the std2 is the square
of the standard deviation. To get the real std you need to take the
square root of it).

Note, its only the same if I remove the key +=3D key >> shift part. With
that still in, it becomes a little different:

max=3D15440573 min=3D334 total=3D139895258 avg=3D2134 std2=3D19938

It actually does better!

 std 141.201 (sqrt(19938)) vs 236.488 (sqrt(55927))

Thus, are you OK if I keep this patch as is?

-- Steve

>=20
> and you do not need to do any additional manipulation of the key (PID).
> Also the function has to return uint16_t.
>=20
> Thanks!
> Yordan
>=20
> >   }
> >  =20
> >   static struct kshark_task_list *
> > -kshark_find_task(struct kshark_context *kshark_ctx, uint8_t key, int p=
id)
> > +kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int =
pid)
> >   {
> >   	struct kshark_task_list *list;
> >  =20
> > @@ -280,9 +280,12 @@ static struct kshark_task_list *
> >   kshark_add_task(struct kshark_context *kshark_ctx, int pid)
> >   {
> >   	struct kshark_task_list *list;
> > -	uint8_t key;
> > +	uint32_t key;
> >  =20
> >   	key =3D knuth_hash(pid);
> > +	key +=3D key >> KS_TASK_HASH_SHIFT;
> > +	key &=3D (1 << KS_TASK_HASH_SHIFT) - 1;
> > +
> >   	list =3D kshark_find_task(kshark_ctx, key, pid);
> >   	if (list)
> >   		return list;
> > diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
> > index 04e9cbfc..3407db19 100644
> > --- a/kernel-shark/src/libkshark.h
> > +++ b/kernel-shark/src/libkshark.h
> > @@ -72,7 +72,8 @@ struct kshark_entry {
> >   };
> >  =20
> >   /** Size of the task's hash table. */
> > -#define KS_TASK_HASH_SIZE 256
> > +#define KS_TASK_HASH_SHIFT 16
> > +#define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
> >  =20
> >   /** Linked list of tasks. */
> >   struct kshark_task_list {
> >  =20


--MP_/kxQ/_qAO2dRwvk5eu2bI8cz
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=hash32.patch

diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 4201fa02..f8f032e0 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -252,19 +252,19 @@ void kshark_free(struct kshark_context *kshark_ctx)
 	free(kshark_ctx);
 }
 
-static inline uint8_t knuth_hash(uint32_t val)
+static inline uint32_t knuth_hash(uint32_t val)
 {
 	/*
-	 * Small table hashing function adapted from Donald E. Knuth's 32 bit
+	 * Hashing function adapted from Donald E. Knuth's 32 bit
 	 * multiplicative hash.  See The Art of Computer Programming (TAOCP).
 	 * Multiplication by the Prime number, closest to the golden ratio of
-	 * 2^8.
+	 * 2^32.
 	 */
-	return UINT8_C(val) * UINT8_C(157);
+	return val * UINT32_C(2654435761);
 }
 
 static struct kshark_task_list *
-kshark_find_task(struct kshark_context *kshark_ctx, uint8_t key, int pid)
+kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int pid)
 {
 	struct kshark_task_list *list;
 
@@ -276,13 +276,20 @@ kshark_find_task(struct kshark_context *kshark_ctx, uint8_t key, int pid)
 	return NULL;
 }
 
+static int hash_list[KS_TASK_HASH_SIZE];
+
 static struct kshark_task_list *
 kshark_add_task(struct kshark_context *kshark_ctx, int pid)
 {
 	struct kshark_task_list *list;
-	uint8_t key;
+	uint32_t key;
 
 	key = knuth_hash(pid);
+//	key += key >> KS_TASK_HASH_SHIFT;
+	key &= (1 << KS_TASK_HASH_SHIFT) - 1;
+
+	hash_list[key]++;
+
 	list = kshark_find_task(kshark_ctx, key, pid);
 	if (list)
 		return list;
@@ -680,6 +687,30 @@ static void free_rec_list(struct rec_list **rec_list, int n_cpus,
 	free(rec_list);
 }
 
+static void print_hash(void)
+{
+	int min = -1, max = -1;
+	int total = 0, avg, std = 0;
+	int i;
+
+	for (i = 0; i < KS_TASK_HASH_SIZE; i++) {
+		if (min < 0 || hash_list[i] < min)
+			min = hash_list[i];
+		if (max < 0 || hash_list[i] > max)
+			max = hash_list[i];
+		total += hash_list[i];
+	}
+	avg = total / KS_TASK_HASH_SIZE;
+	for (i = 0; i < KS_TASK_HASH_SIZE; i++) {
+		int diff = hash_list[i] - avg;
+
+		std += diff * diff;
+	}
+	std /= KS_TASK_HASH_SIZE - 1;
+	printf("max=%d min=%d total=%d avg=%d std2=%d\n",
+	       max, min, total, avg, std);
+}
+
 static ssize_t get_records(struct kshark_context *kshark_ctx,
 			   struct rec_list ***rec_list, enum rec_type type)
 {
@@ -793,6 +824,7 @@ static ssize_t get_records(struct kshark_context *kshark_ctx,
 		total += count;
 	}
 
+	print_hash();
 	*rec_list = cpu_list;
 	return total;
 
diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
index 04e9cbfc..3407db19 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -72,7 +72,8 @@ struct kshark_entry {
 };
 
 /** Size of the task's hash table. */
-#define KS_TASK_HASH_SIZE 256
+#define KS_TASK_HASH_SHIFT 16
+#define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
 
 /** Linked list of tasks. */
 struct kshark_task_list {

--MP_/kxQ/_qAO2dRwvk5eu2bI8cz
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=hash16.patch

diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index 4201fa02..ba0ab813 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -252,19 +252,19 @@ void kshark_free(struct kshark_context *kshark_ctx)
 	free(kshark_ctx);
 }
 
-static inline uint8_t knuth_hash(uint32_t val)
+static inline uint16_t knuth_hash(uint32_t val)
 {
 	/*
-	 * Small table hashing function adapted from Donald E. Knuth's 32 bit
+	 * Hashing function adapted from Donald E. Knuth's 32 bit
 	 * multiplicative hash.  See The Art of Computer Programming (TAOCP).
 	 * Multiplication by the Prime number, closest to the golden ratio of
-	 * 2^8.
+	 * 2^32.
 	 */
-	return UINT8_C(val) * UINT8_C(157);
+	return UINT16_C(val) * UINT16_C(65537);
 }
 
 static struct kshark_task_list *
-kshark_find_task(struct kshark_context *kshark_ctx, uint8_t key, int pid)
+kshark_find_task(struct kshark_context *kshark_ctx, uint32_t key, int pid)
 {
 	struct kshark_task_list *list;
 
@@ -276,13 +276,18 @@ kshark_find_task(struct kshark_context *kshark_ctx, uint8_t key, int pid)
 	return NULL;
 }
 
+static int hash_list[KS_TASK_HASH_SIZE];
+
 static struct kshark_task_list *
 kshark_add_task(struct kshark_context *kshark_ctx, int pid)
 {
 	struct kshark_task_list *list;
-	uint8_t key;
+	uint16_t key;
 
 	key = knuth_hash(pid);
+
+	hash_list[key]++;
+
 	list = kshark_find_task(kshark_ctx, key, pid);
 	if (list)
 		return list;
@@ -680,6 +685,30 @@ static void free_rec_list(struct rec_list **rec_list, int n_cpus,
 	free(rec_list);
 }
 
+static void print_hash(void)
+{
+	int min = -1, max = -1;
+	int total = 0, avg, std = 0;
+	int i;
+
+	for (i = 0; i < KS_TASK_HASH_SIZE; i++) {
+		if (min < 0 || hash_list[i] < min)
+			min = hash_list[i];
+		if (max < 0 || hash_list[i] > max)
+			max = hash_list[i];
+		total += hash_list[i];
+	}
+	avg = total / KS_TASK_HASH_SIZE;
+	for (i = 0; i < KS_TASK_HASH_SIZE; i++) {
+		int diff = hash_list[i] - avg;
+
+		std += diff * diff;
+	}
+	std /= KS_TASK_HASH_SIZE - 1;
+	printf("max=%d min=%d total=%d avg=%d std2=%d\n",
+	       max, min, total, avg, std);
+}
+
 static ssize_t get_records(struct kshark_context *kshark_ctx,
 			   struct rec_list ***rec_list, enum rec_type type)
 {
@@ -793,6 +822,7 @@ static ssize_t get_records(struct kshark_context *kshark_ctx,
 		total += count;
 	}
 
+	print_hash();
 	*rec_list = cpu_list;
 	return total;
 
diff --git a/kernel-shark/src/libkshark.h b/kernel-shark/src/libkshark.h
index 04e9cbfc..3407db19 100644
--- a/kernel-shark/src/libkshark.h
+++ b/kernel-shark/src/libkshark.h
@@ -72,7 +72,8 @@ struct kshark_entry {
 };
 
 /** Size of the task's hash table. */
-#define KS_TASK_HASH_SIZE 256
+#define KS_TASK_HASH_SHIFT 16
+#define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
 
 /** Linked list of tasks. */
 struct kshark_task_list {

--MP_/kxQ/_qAO2dRwvk5eu2bI8cz--
