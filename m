Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211BE17B43F
	for <linux-trace-devel@vger.kernel.org>; Wed, 31 Dec 2025 00:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767141563; cv=none; b=HcROmMZsTabrzV9n0dKhsTt37G2N92R0HoB1rb70vBBneOLcdLiCyKYslPKmrYhAxjHMIbkBimWtZMOQ/TAb7bcxnxmoxScRLvxLt3kRGhn6Eun6TNDllzlKKFiI+fw14JeglNJedca4hY37wbeSpkDPTjC5DviW4izOtQrRITo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767141563; c=relaxed/simple;
	bh=VPvX6HMWJiDbCwJdFLnKpmHGqkY/HFpmnOtjiyZTkS0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=pq/4sw1fRb0fvScTB/uWTnp0rlHwY5mUj1kA6fvLwLHpYkDRVtpFQLcsdyQJ2+Fu0OxVgGsHDKNhaK0o3go30f3znN71GLfQxCfTEceY5iX6QaCPBGLX1CCcDzmaLTpmJaXUvcIm+SpJPmFdD0JPavHvfieB/QHxMOtc4t/cZhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01BC21A4C8E
	for <linux-trace-devel@vger.kernel.org>; Wed, 31 Dec 2025 00:39:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id C12652000D
	for <linux-trace-devel@vger.kernel.org>; Wed, 31 Dec 2025 00:39:12 +0000 (UTC)
Date: Tue, 30 Dec 2025 19:39:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Do not have utest fail debugfs/tracing not
 found
Message-ID: <20251230193921.43e478a7@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5mdptafr87xzdjxt17y5an3f88qgtqzd
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: C12652000D
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19dOD3ZhVSIZqaNOIXFdqk2+TgKyy/v7qE=
X-HE-Tag: 1767141552-636573
X-HE-Meta: U2FsdGVkX1+JFHRx+rmQG3fpZ04Phk92esttnAe7Op0j919rS+Nt87dupjC4QzWCmyQ+NcGlRYa/jbgXGhixBcF0QUC93WWvADn0BRIukH+MaDKGdn/pdf+Rvbkd8Rr9pQyAjb10zwUDoWPcRce9e3vUpFk71JaqStU26X+mBLR/7etn7UyMeQQUXjDuu1u2zIBYgeN8CJaceU6MKjButWWhIEr5v1tX6LgfenYJe6fk+WD5HqLiTBCaP3hJiSKvu4DNn1emgSU/illkQRhlk10SX3PXnBy4M7sd6Uf07rHFntHdnMelbyo5rwUM3kJzolr9c9MkB4wlusKKN6dqanOf1DCssAWuNE7JZ3+Gy5+WHHcRDv4k67veGSop+sRJ

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that the tracing directory in debugfs is obsolete and will be removed
in the future. Do not fail the mount test when looking for the
debugfs/tracing directory.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 4a412b20cdb8..97a91dfcdb2c 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1860,10 +1860,7 @@ static void test_mounting(void)
 			printf("debug directory mounted at '%s'\n",
 			       debug_dir);
 
-		/* Make sure the directory has content.*/
-		asprintf(&path, "%s/tracing", debug_dir);
-		CU_TEST(stat(path, &st) == 0);
-		free(path);
+		CU_TEST(stat(debug_dir, &st) == 0);
 	}
 
 	if (save_debug)
-- 
2.51.0

