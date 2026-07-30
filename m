Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD1C4457DD
	for <linux-trace-devel@vger.kernel.org>; Thu, 30 Jul 2026 16:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428419; cv=pass; b=IFR20ZCgv1aHoQG+f3Ks47TMMb6N/2719IrkkjNFOgaYq8VBaUJX4Z4Sj4GksLIrGfH0CzTKngK85ebnwsUGDFuTx907kKIkwuULbBW3GGINa4Kds0+6syFqyVVdhszVoB+mxxCIDL11tZY0PggO05t9be7YgH8dEq3SVC9H70Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428419; c=relaxed/simple;
	bh=7ukM5YijNXYO87UbDpzLv+fXx9Z0jHliPyxf921BwoE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=U3nOQdVF99w9zLo2IJ1rc9ahA/wsQLc1Rl+yk5UAJT++d4AcWYtSezJuAW2x//887y+7rAuTpPxEhNRyiVIdgbb876OxDFeSafuvOheYzhqMdceK8B8v+G8dUVXrX913l/pgWBveAUJDtSB3Ly33A839WfJpnIatO3N6040gAe0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=p9m3Ulk6; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=5LrGqoQ3; arc=pass smtp.client-ip=85.215.255.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="p9m3Ulk6";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="5LrGqoQ3"
ARC-Seal: i=1; a=rsa-sha256; t=1785428049; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Ksu/j4eUQDN5lPsLSHsLnRFwkX7Jhyh8DPpLFuDS3ranMRXX/oDWcxOogBXPZOzDll
    /1OwlliCg3r7+lU5JIek+Zj9rFL7nzcWEWfYGpTsfQ5xuu71l2OL1m/+jze0EwGuuo7t
    4E2spb1FtbRJPT0y0v918cN8wl4SUzPgZBQzO2l5ZoplyhKEygMpomOhjAeV378lY+Bd
    JINx/Ig4GmakF2ie25wV5YridfnYvLNsH5KcC1/VTwyGQTj1nCZuqO2YbWvOluo91gLy
    qp8rDXbXp2u3Qn84UO0Y9/9UzB9Z544wwHvlz1+SWgrmXbxZWN6KZ5O9HJlpdFxMsq1M
    0G9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1785428049;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=xTelQpZEZsl5OiYje06VK7cwJRbz8pmKlF2dnK0xojo=;
    b=MeZmn0HniC/xt4clbjy1I6msVGn6GK8T7fsdQTtoNLZKbX1DtmjHHL+OysR2ZipYrc
    1resHddteo+0/gZK5/iJjTE6Fd/7ptVXOAIO82CTje56dySFYl40m/lnRVNgr+uAhGpE
    PHG9vsUjhwitVM2B+16lGZv8gqZYT6jvuzLtRfrjO5x8deGbmA5jrB2X3WmP/G9XN7VA
    jW/hS74l4kg18vQIqBQ7u2On7LAvJ1j5GymxR8NI8JY3aw1Jvn1c1Oj0RmQhkKm9QTBP
    EgrFPc3K2qWXdTwtdHaMI8jEGwZkLLTnnuXl0pvFdJrIW+gYxoXsWNdmPFIaF5zFYJVC
    lQvA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1785428049;
    s=strato-dkim-0002; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=xTelQpZEZsl5OiYje06VK7cwJRbz8pmKlF2dnK0xojo=;
    b=p9m3Ulk6B8w3FOXyzQ6r6Hb/xWp6mXdApOUt1+OyOEcXgyoBVXyKYzv7/zU3rnOYco
    A6F4LPNUJqaPpnxEb3moNNP+XF57XCQQfrRM/BIcb1xfybupv2Ui4D8LRTmQEc7Ti0KJ
    baHTaptPRb2isjCMudD0HpC9nxOetevtVwtMnCfbcRokytHskma5zy6Kg8bh4/5NhAvf
    BHPZG8eWQL9LMmjMdBdf8tCmcqBpod2KbmktxeR8S3VbQs0pkiUU6Q2aAbyQg7ym17uz
    J0A36jZCgSUa0IFPxZSV1v0D0FyJu4qvQyVJA2ft8eoWlKtZIdVX1h4rmR+YpbXnt2Zt
    vNhw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1785428049;
    s=strato-dkim-0003; d=iokpp.de;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=xTelQpZEZsl5OiYje06VK7cwJRbz8pmKlF2dnK0xojo=;
    b=5LrGqoQ3xe63P+kv3rP795Jz4YPwnfJQBO7VmlbECwCYGO59gMFpb38RBSJgpiBlQ6
    uuicCs53BzAq1AIovDBw==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSfNuhhDSDt3O2J2YOom0XQaPis+nU/xK"
Received: from Munilab01-lab.micron.com
    by smtp.strato.de (RZmta 55.5.6 AUTH)
    with ESMTPSA id zeddc926UGE8kBw
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Thu, 30 Jul 2026 18:14:08 +0200 (CEST)
From: Bean Huo <beanhuo@iokpp.de>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH] libtracefs: Fix memory leak in tracefs_tracing_dir_is_mounted()
Date: Thu, 30 Jul 2026 18:13:59 +0200
Message-Id: <20260730161359.506565-1-beanhuo@iokpp.de>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="us-ascii"

From: Bean Huo <beanhuo@micron.com>

tfs_find_debug_tracing_dir() returns a newly allocated string on every
call, and the caller owns it -- tfs_find_tracing_dir() documents that the
result "must be freed by free()". But tracefs_tracing_dir_is_mounted()
passes that pointer straight out through @path, whose own documentation
says it "must not be freed".

The two contracts cannot both hold: the allocation is unreachable the
moment the function returns, and no caller is permitted to release it. The
result is a leak of the tracing directory path on every call, and two of
them when the directory was not mounted and @mount asked for it to be.

valgrind on an application that calls it once at startup:

  20 bytes in 1 blocks are definitely lost in loss record 2 of 3
     at 0x4848899: malloc
     by 0x4A2C58E: strdup (strdup.c:42)
     by 0x13014C: find_tracing_dir (tracefs-utils.c:155)
     by 0x1301A7: tracefs_tracing_dir_is_mounted (tracefs-utils.c:178)

The library already keeps exactly the cache this function needs:
tracefs_tracing_dir() memoises the path in a static, revalidates it with
test_dir(), and is documented as returning a string that must not be
freed. Use tfs_find_debug_tracing_dir() only to probe -- it is still needed
for that, because unlike tracefs_tracing_dir() it can be told not to mount,
which is what @mount == false requires -- then release the probe copy and
return the cached path.

Note this changes @path when a custom directory is in effect: it now
reports tracefs_set_tracing_dir()'s value rather than the detected mount
point. That makes @path agree with the directory the rest of the library
actually operates on, which seems the more useful answer, but it is a
visible change and not merely an internal cleanup. The return value is
unaffected -- it still comes from probing the real mount state.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 src/tracefs-utils.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index d1aced0..96a1fa9 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -173,12 +173,19 @@ __hidden char *tfs_find_debug_tracing_dir(bool debugfs, bool mount)
  */
 int tracefs_tracing_dir_is_mounted(bool mount, const char **path)
 {
-	const char *dir;
+	char *dir;
 
+	/*
+	 * tfs_find_debug_tracing_dir() allocates a new string on every call
+	 * and the caller owns it, but @path is documented as not freeable.
+	 * Use it only to probe (unlike tracefs_tracing_dir() it can be told
+	 * not to mount), then hand back the cached path the library owns.
+	 */
 	dir = tfs_find_debug_tracing_dir(false, false);
 	if (dir) {
+		free(dir);
 		if (path)
-			*path = dir;
+			*path = tracefs_tracing_dir();
 		return 1;
 	}
 	if (!mount)
@@ -187,8 +194,9 @@ int tracefs_tracing_dir_is_mounted(bool mount, const char **path)
 	dir = tfs_find_debug_tracing_dir(false, mount);
 	if (!dir)
 		return -1;
+	free(dir);
 	if (path)
-		*path = dir;
+		*path = tracefs_tracing_dir();
 	return 0;
 }
 
-- 
2.34.1

